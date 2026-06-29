---
name: dev-standards
description: 通用开发规范——设计原则(第一性原理/删机制优于加机制)、开发流程(feature→issue→codex 审→集成分支→push)、提交规范(每TODO一commit)、DB/Redis 硬规范(禁全表/全库扫、过 EXPLAIN)、协作与沟通风格。任何业务场景 skill 引用本 skill;做方案评审、写代码、提交、改 DB/Redis 前过一遍。
---

# dev-standards — 通用开发规范(所有场景共享的底座)

被各业务场景 skill 引用的"怎么干活"真相源。**一份在此,别在各场景 skill 里重抄。** 详细分篇按需读。

## 5 秒核心(动手前过一遍)
- **第一性原理审题,优雅方案直击本质**:很多"问题"是上游设计缺陷的症状——修设计让问题**蒸发** > 技术上"解决"它。新问题按序自问:①是不是上个补丁的债 ②需求本身合理吗(需求是输入不是圣旨)③是不是设计缺陷的症状 ④能不能删掉一个东西让问题不存在 ⑤确需新增,用最简模型卡它。
- **删机制优于加机制**:新症状先怀疑上个补丁的债,回去拔根因,别堆保护层。
- **简洁链路 / 行业标准 / 不过度封装 / 以少为多**:数据流一条线讲完;有惯例用惯例;抽象等第二个使用者。
- **方案必带可行性证明,不假设**:提方案就给"行得通"的证据(POC/实测/事实/先例);"应该可以/默认如此"= 未验证假设,要么去证、要么显式标"未证"。

## 几条铁律(违反易致线上事故)
- **每条 TODO 单独 commit**,message 引用 TODO/issue 编号。
- **不在集成分支直接提交**;本地 merge 后**必须 push**(远端部署拉 origin)。
- **线上严禁全表扫 / 全库扫**:Redis 不许 `KEYS`/`SCAN MATCH` 扫 keyspace;MySQL 大表每条 SQL 过 EXPLAIN(`type≠ALL`、命中选择性索引,选择性以真实 `rows` 为准)。
- **对外字段先问类型/宽度/字符集**;改 hash/签名算法必升版本同步 fixture。
- **新代码单文件 ≤ 500 行**:超了按职责拆(不是机械截断);存量超标文件不强制重构,但新代码不准再叠(详见 design-principles.md 判据 7)。

## 分篇(按需读)
| 篇 | 看什么 |
|---|---|
| [design-principles.md](design-principles.md) | 设计原则:方案评审先过这关 |
| [dev-flow.md](dev-flow.md) | 开发流程:feature → issue → codex 审 → 集成分支 → push;worktree |
| [db-conventions.md](db-conventions.md) | MySQL/Redis 硬规范:禁全表/全库扫、索引选择性、事务/锁 |
| [collaboration.md](collaboration.md) | 协作分层与沟通风格(汇报先结论、大白话、不堆黑话) |

> 验证闭环 / 数据操作 SOP 带项目味道,留在各业务场景 skill。
