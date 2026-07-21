---
name: <项目短名,kebab-case>
description: <一句话:这个项目认知包覆盖什么;什么时候用它。让 agent 知道何时该读它。>
---

# <项目名>

一句话定位:<这个项目是什么、要解决什么、现在主战场在哪>。

## 铁律(违反即事故)
1. **<硬约束>**:<为什么不能违反 + 违反后果>。
2. …

## 层级(依赖单向,引用不复制)

元事实(knowledge/lessons/troubleshooting,表格化分领域)← 工作单元(工作区根 `issues/`,bug/需求一事一文件,与 forge/评审文档同步)← 交接(handoff.md,只指路)。元事实永不引用工作单元。

## 目录(你要干什么 → 读哪)
```
knowledge/        元事实(概念/架构/契约/环境;可枚举的用表格)
lessons/          heuristics 决策法则 + case-studies 复盘
troubleshooting/  症状→根因索引 + 现成命令
handoff.md        交接(主线指针+在飞清单,完结即删行)
../issues/        工作单元(工作区根,skill 只放指针)
tools/            诊断 CLI
```

## 维护(谁改谁更新)
| 触发 | 更新 |
|---|---|
| 会话开始 | 读 handoff.md(→在飞 issues/ 文件)+ 近期改动 |
| 在飞工作有进展/证据 | 写进 issues/ 对应文件;handoff.md 只动指针行 |
| 撞到新症状/弯路 | troubleshooting/;可泛化的进 lessons/heuristics.md |
| 有了新的慢变认知 | knowledge/ 对应文件,起清晰小节,≤100 行 |
| 链路/契约/铁律变更 | 同一工作单元内改完对应文件 |

> 通用开发规范不写在这里——引用 `dev-standards`。
