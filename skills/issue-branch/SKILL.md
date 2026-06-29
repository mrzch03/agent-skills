---
name: issue-branch
description: issue 优先 + 带编号分支的开发纪律。任何新功能/改 bug/重构,先建 issue(目标/背景/范围),再从它派生带 issue 编号的分支,commit 引用编号,PR/MR 关闭 issue。当用户说"开 issue/建分支/开始做 X"时使用。工具无关(GitHub/GitLab/本地 markdown 均可)。
---

# issue-branch — issue 优先 + 带编号分支

强制顺序:**Issue → 分支(含编号)→ 开发 → PR/MR(关闭 Issue)**。即使有人直接说"建个分支叫 fix-xxx",也**先建 issue 再派生**。绝不在没有关联 issue 的情况下建分支/MR——否则工作无来由、无归档、无验收。

## 步骤
1. **建 issue**:写背景 + 目标 + 范围(**不含实现**)。issue tracker 按你项目约定:GitHub issue / GitLab issue / 无 forge 时 `.scratch/issues/` 下 markdown。
2. **派生分支**:`feat/<issue号>-<topic>` 或 `fix/<issue号>-<topic>`,从最新集成基线切。
3. **commit 引用编号**:每条 TODO 单独 commit,message 带 issue 号(见 `dev-standards` 提交规范)。
4. **PR/MR**:描述写 `Closes #<号>`,合入即关 issue。

## 工具无关
- GitHub:`gh issue create` / `gh pr create`。
- GitLab:`glab` 或 REST API(token 走环境变量如 `$GIT_FORGE_TOKEN`,**不硬编码**)。
- 无 forge:issue 写成 `.scratch/issues/<id>.md`,分支名仍带该 id。
