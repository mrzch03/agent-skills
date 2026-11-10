# MySQL 检查要点

先记录版本、存储引擎、隔离级别和数据规模。此页依据 MySQL 8.4 文档核对（2026-11-10），不代替旧版本兼容性检查。

- 查看执行计划的访问路径、估算行数和过滤条件，必要时在授权环境实测；`EXPLAIN ANALYZE` 会执行查询。
- `type=ALL` 是检查信号，不自动等于故障；结合规模、返回比例、频率与实际耗时判断。低基数列也可能因分布偏斜对特定值有选择性。
- MySQL 8.4 支持 Hash Join，不能以“不支持”为由一律拆 JOIN；比较计划、数据量及往返成本。
- 锁定读支持 `NOWAIT` 和 `SKIP LOCKED`，具体行为以版本为准。它们有不同业务语义，不能用降低等待时间代替并发正确性设计。
- 不机械将非主键 UPDATE 改为先 SELECT 再 UPDATE；先明确竞争窗口、条件是否可能变化、事务及锁范围。
- 大批量变更结合锁时间、日志、复制延迟和恢复进度设定批次，验证迁移中的读写兼容。

依据：[EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html)、[Hash Join](https://dev.mysql.com/doc/refman/8.4/en/hash-joins.html)、[锁定读](https://dev.mysql.com/doc/refman/8.4/en/innodb-locking-reads.html)。
