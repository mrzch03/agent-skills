---
name: codex-review
description: 对本地分支改动做一次独立评审(codex CLI 或任意独立 reviewer):喂规范+需求背景+技术方案,让它独立读 diff 与上下文,出 VERDICT(APPROVE / CHANGES_REQUESTED)。当用户说"走流程/独立审/codex review/审这个分支/审 MR"时使用。是 feature-flow / hotfix-flow 的评审闸门。
---

# codex-review — 独立评审闸门

代码写完后,用一个**独立** reviewer 审本地分支改动。它独立读 diff + 自取上下文,不靠你转述。

## 怎么做
1. 在仓库根,让 reviewer 看改动:`git diff <集成基线>...<feat分支>`(**只审一笔**用 `git show <commit>`,别带整条分支的无关改动)。
2. **喂全上下文**:开发规范(`dev-standards`)+ 需求背景 + 技术方案(文档链接/正文)一起给——否则是空审 diff。
3. 评审标准:正确性(逻辑/边界/并发/回归)、**直击本质非堆机制**、与仓内约定一致;**性能必查**(共享 Redis 禁全库扫、大表 SQL 过 EXPLAIN、警惕无界大 key 读);**新增/改 SQL 必带 EXPLAIN**(无则判 CHANGES_REQUESTED)。
4. 输出第一行 **`VERDICT: APPROVE` 或 `VERDICT: CHANGES_REQUESTED`**,之后列依据。

## 闸门
- **CHANGES_REQUESTED** → 改完**同分支再审**,直到 APPROVE。
- **APPROVE** → 进测试 / 合入。
- 结论贴到对应 issue/MR 留痕;没有就汇报给用户。

## 工具无关(codex CLI 是一种实现)
任意能"独立读 diff + 出 VERDICT"的 reviewer 都行。**read-only 评审**,别让它改代码。
用 codex CLI 时:`codex exec --sandbox read-only "<评审 prompt>" < /dev/null`(显式喂 stdin,后台/非 TTY 才不会卡);输出重定向到文件再读,别 `| tail`;推理要几分钟,没输出别杀进程。
