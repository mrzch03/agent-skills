# 数据库 / Redis 开发规范(违反易致线上事故)

前提:线上 MySQL 多张 20w+ 行的大表;Redis 是多个服务共享的单实例。
任何全表扫 / 全库扫一发就拖垮一片。下面是硬规范 + 踩过的坑(曾有 `KEYS` 打满共享 Redis)。

## 强制流程:每条 SQL 上线前必过 EXPLAIN(不是建议,是关卡)

**新增或改动的每一条 SQL,提交前都要拿到它的 EXPLAIN 执行计划并贴出来**(动态拼接的 SQL 按代表性参数取一份)。判读三看:
- `type`:`ALL` = 全表扫,**直接打回**;期望 `ref`/`range`/`const`/`eq_ref`。
- `key`:实际命中的索引是不是你预期的那个;`possible_keys` 有但 `key` 选了低区分度的(如 `status`)= 危险,要改索引或调查询。
- `rows`:估算扫描行数,**按线上量级判断**(测试库行数小会把 `rows` 估成 1 骗过你,见下"验证手法")。
另注意 `Extra`:`Using filesort`/`Using temporary` 在大结果集上要警惕。
EXPLAIN 结论进 codex 评审留痕(见 dev-flow.md 第 4 步);SQL 改动**没有 EXPLAIN = 不予 APPROVE**。

## Redis(共享实例,单线程,最致命)

- **线上严禁 `KEYS`,严禁 `SCAN MATCH` 扫全 keyspace**。代价是 **O(整库 key 数),与匹配数无关** —— 匹配 0 条也要遍历整库;单线程 Redis 被独占期间所有客户端一起卡。客户端超时**救不了**已经在 Redis 上跑的扫描(服务端照样扫完才停)。
- **要按集合枚举 key,维护一个显式索引 SET/ZSET,别拿前缀去 `KEYS prefix:*`**。命名空间前缀是给点查用的,不是给扫描用的。
- **房间/对象发现走 SQL 选择性索引或 MQ 事件,不扫 key**。某服务曾用 `SCAN <prefix>_*` 发现对象,测试库 14000+ key 单轮分钟级,已删。
- **单 key 全量读(`SMembers`/`HGetAll`/`ZRANGE 0 -1`/`LRANGE 0 -1`)只在该 key 大小有明确上界时才用**。会随业务无限增长的 SET/ZSET/LIST 要分页(带 offset/count)或换结构。这类是 O(单个 key),不是全库扫,但大 key 同样阻塞。
- **调试 / 监控端点尤其要克制**:大盘每 3s 轮询一次,一个全库扫端点 = 持续打击。监控的"本机状态"从**内存**拿,不去 Redis 反推;Redis 只用来读"本就是外部状态"的有界数据(如某房间队列 `ZCARD`)。

## SQL(MySQL,无 hash join,主键最快)

### 本项目最容易踩
- ⚠️ **选择性靠 EXPLAIN 的真实 `rows` 判,别靠 `SHOW INDEX` 的 cardinality 猜**。基数低 ≠ 命中多:某 20w 行大表、某 `status` 列基数仅 2,曾据此断言 `WHERE status=3` 命中近半表=全表扫——**线上 EXPLAIN 实测打脸**:status=3 只 ~1156 行(占总量 ~0.6%,分布偏斜),`type=ref` 走索引,不是全表扫。教训:分布偏斜时低基数列对某个具体值也可能很有选择性,**cardinality 是估值会骗人,EXPLAIN 跑线上量级才算数**(测试库行数小,`rows` 也会估成 1 骗你)。
- 想再快/未来防护:给高选择性等值列建复合索引(如 `(type, status)`,用高区分度列直接缩到目标子集),让查询只扫目标子集而非"先捞全部再过滤"。但属优化,先 EXPLAIN 确认现状是否真的需要,别凭基数臆断就加索引(规范 #1 简单优先)。
- 关联查询:关联列两边都要有索引;B 表 where 用 y、关联用 x → 建 `(y, x)` 复合索引;`group by`/`order by` 只能用一个表的列。

### 硬规范(逐条)
1. 能按主键查/改就按主键;复杂 SQL MySQL 跑得慢,尽量简单。
2. 要 MySQL 做的明确写出来,别赖默认机制:用 `LIMIT` 必带明确 `ORDER BY`,不靠默认排序。
3. 没必要不开事务;事务尽量小,能不放事务里的 SQL 就别放。
4. **超过 1000 行的表必须按索引列查**。
5. 禁止按无索引列做 `UPDATE`(满足条件的行全被锁)。按非主键改 → 先 `SELECT id WHERE ...` 再 `UPDATE ... WHERE id IN(...)`。
6. 禁止存储过程 / 触发器 / 自定义函数。
7. 禁止 `LOCK TABLE` 等显式加锁语句。
8. 一般不用 `SELECT FOR UPDATE`,用乐观锁;需要时 `set session innodb_lock_wait_timeout=1` 替代(MySQL 无 nowait)。
9. 事务内加锁后不要跟长 SQL(锁迟迟不释放);谨慎设计事务顺序避免死锁。
10. 避免两个大表直接 join(MySQL 无 hash join),拆成多次单表查;避免过多表关联。
11. 大批量 `UPDATE`/`DELETE` 切批,每批 ≤1w 行(防性能问题 + 主从延迟)。
12. 线上库别跑大量计算 / 统计 SQL。
13. 合理分页:深 `LIMIT 10000,100` 越翻越慢,别用;不需要全量就带 `LIMIT`,且不依赖默认排序。
14. **任何情况不 `SELECT *`**,只查需要的列。
15. `UPDATE`/`DELETE` 不带 `LIMIT`(防主从不一致)。
16. 避免子查询,拆多次查询或改写为表连接。
17. 用 `COUNT(1)` 数行,别 `COUNT(具体列)`。
18. or 同字段 → `IN`;or 不同字段 → `UNION`。
19. 避免反条件:`NOT` / `!=` / `<>` / `NOT IN` / `NOT LIKE` / `NOT EXISTS`。
20. 避免 `LIKE '%xxx'` 前缀通配(走不了索引)。
21. 标准 SQL 能实现的,不用 MySQL 专用语法。

## 验证手法(只读,跑完即删)
用只读账号在贴近线上量级的库上跑 `EXPLAIN <你的 SQL>`,
看 `type`(ref/range 好,ALL=全表扫)、`key`(选中哪个索引)、`rows`(估算扫描行数);
配 `SHOW INDEX FROM <表>` 看列的 `Cardinality`(基数小=区分度低,别指望它当过滤索引)。
⚠️ 用线上量级判断,测试库行数太小会把 `rows` 估成 1 骗过你。
