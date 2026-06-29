# 开发流程

0. **方案先过 [design-principles.md](design-principles.md)**:这是不是设计缺陷的症状?能不能让问题蒸发而不是被解决?
1. **动手前**:读 SKILL.md 铁律 + 场景 skill 的 progress.md(验证状态/弯路) + 相关仓库近期 `git log`;干什么听用户派(任务/issue);确认在开发分支(merge 后 HEAD 常停在集成分支,易误提交)。
2. **开发**:**从最新 `origin/<集成基线>`(如 release)切 feature 分支**(`git fetch origin release && git checkout -b feature/<topic> origin/release`);每条 TODO 单独 commit,message 带编号(`[模块 Px]`)。
3. **方案留痕**:重要方案/争议决策提到你的 issue 跟踪系统,结论回填。用 git forge API 留痕的示例(以 `$GIT_FORGE_TOKEN` 鉴权,host/项目 ID 换成你自己的):
   ```bash
   curl -s -X POST -H "PRIVATE-TOKEN: $GIT_FORGE_TOKEN" \
     "https://<your-git-host>/api/v4/projects/<项目ID>/issues" \
     --data-urlencode "title=<标题>" --data-urlencode "description=<正文(markdown)>"
   ```
4. **独立审**:codex 直接审**本地分支**——`cd 仓 && codex exec "评审 feature/x 相对集成分支的改动(git diff <集成分支>...feature/x), 自行读文件取上下文, 第一行 VERDICT..."`(read-only 沙箱,零网络依赖)。VERDICT 贴到 issue/MR 评论留痕。CHANGES_REQUESTED → 改完重审。(正确性=测试+实跑+codex 审 三道。)
   - **性能是必查维度,按 [db-conventions.md](db-conventions.md) 逐条对照**(曾有 `KEYS` 打满共享 Redis 的线上教训):评审 prompt 里要显式点名查——① Redis 有没有 `KEYS`/`SCAN MATCH` 全库扫、无界大 key 读(`SMembers`/`HGetAll`/`ZRANGE 0 -1`);② SQL 有没有大表全表扫(无 `WHERE`/低区分度列索引/`LIKE '%`/反条件/`SELECT *`)、N+1、深分页、两大表 join;③ 监控/调试端点会被轮询,任何扫描都放大。改动碰了 Redis/MySQL 就**必须**让 codex 出"性能 VERDICT",别只看正确性。
   - **SQL 改动必须随附 EXPLAIN 执行计划**(db-conventions 强制流程):新增/改动的每条 SQL 都贴执行计划,`type=ALL`/命中低区分度索引 = 不予 APPROVE。
4b. **写 CHANGELOG**:开发完在仓库 `CHANGELOG.md` 追加一条本次开发单元的记录,**必须列出本次新增/改动的所有 SQL 查询和 Redis 操作**(逐条:操作+key/表+频率+触发点),供性能审计与回溯。无 DB/Redis 改动也写一行"无"。
5. **合入(worktree 模式,主目录永不切分支)**:merge/push 去常驻集成分支 worktree 做——
   ```bash
   W=<仓>-staging-worktree
   git -C $W pull && git -C $W merge feature/<topic> --no-edit && git -C $W push
   ```
   主目录永远停在开发分支,根治"merge 后 HEAD 停集成分支误提交";**push 才算部署**(远端部署拉 origin,merge 不 push 等于没部署)。
   ⚠️ **绝不把集成分支合进开发分支**(集成分支含其他人代码, 开发分支必须纯净):
   feature→集成分支撞冲突就在集成分支 worktree 的 **merge commit 里**解决(merge 提交不算直接提交);
   要改只存在于集成分支的代码(别人引入的文件), 从集成分支拉 fix/* 临时分支改完合回。
6. **验证**:见各业务场景 skill 的验证 SOP——跑应用、看真实行为、出证据。
7. **收尾**:过 SKILL.md 维护检查单——**有才写**(焦点/未验证项/弯路/契约/怪癖),commit 已表达的不复述。

## 并行修改:worktree

常驻 worktree:每个仓库一个集成分支 worktree——只用来 merge/push。
并行开发任务(多会话/人机同时改)每任务一个临时 worktree:
```bash
git -C <仓> worktree add ../.worktrees/<仓>-<任务名> -b feature/<任务名>   # 新建分支并行干
git -C <仓> worktree remove ../.worktrees/<仓>-<任务名>                   # 用完即删
git -C <仓> worktree list                                                # 盘点
```
注意:①同一分支不能同时被两个 worktree 检出(git 自带保护,正好防撞);②需要构建/容器挂载的仓在主目录跑(worktree 里改完先合回再构建);③前端 worktree 要自己 `npm install`(node_modules 不共享)。

git forge token 放 `$GIT_FORGE_TOKEN`(带 api scope,可建 issue/MR)。
