---
name: project-skill-blueprint
description: 为一个项目/业务场景建一个"认知 skill"的骨架蓝图——高内聚、能排障、能跨会话交接。教你该有哪些目录、每篇放什么、怎么维护。要给某个项目沉淀一份"接手即懂"的认知包,或新起一个业务场景 skill 时用本蓝图。
---

# project-skill-blueprint — 项目认知 skill 的骨架

一个"项目认知 skill"= 让任何 agent / 新人**接手即懂**这个项目的认知移植包。它高内聚(只装这个项目的事)、用完即丢(项目结束归档)、能排障、能交接。本蓝图给结构与约定;照着建一份即可。

## 目录骨架(按需取舍,不必全有)
```
SKILL.md           入口:一句话定位 + 铁律 + 目录(要干啥→读哪)+ 维护规则
knowledge/         慢变的事实认知
  concepts.md        术语表 + 核心不变量
  architecture.md    链路 + 职责切分 + 代码锚点
  contracts.md       对外契约(协议/接口/错误码,带对齐日期)
  environment.md     拓扑 / 权限矩阵 / 固定测试资产 / 环境怪癖
lessons/           经验(增长型)
  heuristics.md      决策法则(动手前过一遍,每条带案例锚点)
  case-studies.md    大案复盘(现象→路径→根因→教训,≤10 行/案)
troubleshooting/   排障(按症状索引)
  symptoms-*.md      症状 → 先查 → 历史根因(grep 报错就跳到根因)
  commands.md        现成命令(查日志/查库/常用诊断)
progress.md        轻账本:只存 git 表达不了的(待验证行为 + 已排除假设)
tools/             诊断 CLI(把"每次都重写的查询"固化成脚本)
```

## SKILL.md 四段约定
1. **一句话定位**:这个项目是什么、现在主战场在哪。
2. **铁律(违反即事故)**:跨组件 × 静默变错的硬约束,编号列出。改它前先肃然起敬。
3. **目录(你要干什么 → 读哪)**:把上面的结构列成"任务→文件"导航,别让人翻。
4. **维护(谁改谁更新,人和 AI 同规)**:什么触发更新哪个文件,**同一工作单元内改完**——这是 skill 不腐烂的关键。

## 五条维护纪律(决定它会不会变成没人敢动的大文件)
- **一个事实一个家,永不复制**;通用规范引 `dev-standards`,不在本 skill 重抄。
- **每篇 ≤ 100 行**;超了按主题拆,用时才加载(progressive disclosure)。
- **改代码的同一工作单元更新对应 skill**(skill 即真相,不留滞后)。
- **慢变进 knowledge/,经验进 lessons/,症状进 troubleshooting/,易变状态进 progress.md**;别混。
- **交接** = `progress.md`(git 表达不了的待验证/弯路)+ 会话末写一份续作文档给下一个 agent。

## 怎么起步
1. 复制 `references/skeleton/` 到你的 skill 目录,改 frontmatter 的 name/description。
2. 先写 SKILL.md 的"一句话定位 + 铁律 + 目录";其余文件**有内容再建**,别先摆空壳。
3. 排障时:症状沉淀进 `troubleshooting/`,可泛化的法则进 `lessons/heuristics.md`,跑过的诊断固化进 `tools/`。

> 参考实例:任何成熟的项目认知 skill(knowledge+lessons+troubleshooting+progress+tools 五件套)都是本蓝图的实例。
