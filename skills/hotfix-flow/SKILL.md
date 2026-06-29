---
name: hotfix-flow
description: 小改/紧急修复的轻流程(区别于重型 feature-flow):范围明确、无 schema/接口大依赖的改动走它。定范围/根因 →(可选)issue → 改 → 自测+证据 → 轻评审 → 上线(带回滚)。当用户说"小改/hotfix/紧急修/快速改个 X"时使用。有 DB/接口大依赖或要设计的走 feature-flow。
---

# hotfix-flow — 轻流程(小改 / 紧急修)

适用:范围明确、无 schema/接口大改、不需要技术方案文档的改动。**比 feature-flow 少了技术方案 + 三方评审 + rubric**,但闸门不省:**改了要自测出证据 + 能回滚**。

## 步骤
1. **定范围 / 根因(一句话)**:改什么、为什么——"根因 X 所以做 Y";说不出就还没想清,先想清(第一性原理,见 `dev-standards`)。
2. **(可选)issue**:紧急可先改后补;非紧急走 `issue-branch` 建个轻 issue 留痕。
3. **改**:按 `dev-standards`——每 TODO 一 commit、不在集成分支直接提、DB/Redis 过规范、**单文件 ≤ 500 行**。
4. **自测 + 证据**:走 `verify`——真跑、观察预期、留证据(日志/DB 行/trace)挂 issue。
5. **轻评审**:走 `codex-review`(独立审 diff,带背景)。紧急可先合后补审,但**必须补**。
6. **上线 + 回滚**:说清怎么发、依赖谁、**回滚步骤**;DB 变更仍**兼容 2 版本**。

## 什么时候别用它(升级到 feature-flow)
有 DB schema / 接口改动、要画架构/时序、影响多模块、需要资源协商 → 走 **`feature-flow`**。
