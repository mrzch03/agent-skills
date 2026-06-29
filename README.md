# agent-skills

工程 AI agent 的**通用骨架 skill 集**——自包含、可移植、无项目/公司绑定。把"怎么做需求、怎么定规范、怎么给项目沉淀认知、不确定时从哪起步"沉淀成几个高内聚、用完即丢的 skill。

## 设计哲学(为什么是这几个,而不是一个大 KB)
- **场景化、高内聚、用完即丢**:一个业务场景一个 skill;项目结束就归档,不让知识库膨胀到没人敢动。
- **一份事实一个家,永不复制**:通用规范只在 `dev-standards`;别的 skill 引用它,不重抄。复制 = 漂移腐烂的根源。
- **闭环、不依赖外部**:本仓自给自足,不引用第三方 skill 包;需要的能力我们自己总结成精简版。
- **能交接**:每个项目认知 skill 带 `progress.md`(git 表达不了的状态),会话末写续作文档给下一个 agent。

## 包含的 skill
| skill | 作用 |
|---|---|
| **scenario-map** | 总入口:核心原则(第一性原理/删机制/可行性证明/单文件≤500行)+ "按场景找能力"的路由表(模版,按你的项目填) |
| **dev-standards** | 通用开发规范:设计原则(八条判据)、开发流程、提交规范、DB·Redis 硬规范、协作。被其它场景 skill 引用 |
| **feature-flow** | 做需求的完整 SOP:需求挑战 → issue → 技术方案(模版)→ 评审(rubric/ABCD)→ 开发 → 独立评审 → 测试+证据;每阶段带闸门 |
| **project-skill-blueprint** | 给一个项目/业务场景建"认知 skill"的骨架:目录约定 + 维护纪律 + 可复制 skeleton |

## 安装
```bash
./install.sh              # 软链 skills/* 进 ~/.claude/skills(默认)
./install.sh /path/to/project/.claude/skills   # 或装进某项目的 skills 目录
```
软链方式 = 一份物理、改了即时生效、`git pull` 即更新;不复制、不漂移。

## 在新项目里落地
1. 装上本仓(install.sh)。
2. 把 `scenario-map` 的路由表填成你项目的实际 skill。
3. 用 `project-skill-blueprint` 给项目建一个认知 skill(knowledge/lessons/troubleshooting/progress/tools 五件套)。
4. 做需求走 `feature-flow`;所有 skill 的规范都引 `dev-standards`。

## 维护约定
- 改任何 skill:**一份事实一个家,永不复制**;每篇 ≤100 行,超了拆。
- 新增一个通用场景 skill:在 `scenario-map` 路由表加一行 + 在本 README 表格加一行。
- 这里只放**通用**能力;任何项目/公司专属的内容都不进本仓。
