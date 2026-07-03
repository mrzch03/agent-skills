# portfolio — 全产品审计与姿态(2026-07-03 全量盘点)

> 姿态四档:**主攻**(全力投入)/**供弹**(只做服务主攻线的改动)/**冷冻**(保活不投入,愿景资产)/**独立**(与主线无协同,单独决策)。

## 面向用户的"嘴"(5 个端——乱的主要来源)
| 端 | 是什么 | 状态 | 姿态 |
|---|---|---|---|
| **Tapio iOS** | K12 英语私教(独立仓) | V3 全流程上机,45 测绿 | **主攻** |
| ClawBox iOS (`mobile-ios`) | Live2D 伙伴 IM 陪伴 | 可用,35 测试通过 | 冷冻 |
| Clawdy (`clawdy`+`clawdy-site`) | Tauri 桌宠 | 全功能可用 | 冷冻 |
| im-web | PC/Tablet 学习工作站 | 可用 | 冷冻 |
| live-board-lab (im-web 内) | Gemini Live 实时黑板实验 | 实验 | 冷冻(成果已被 Tapio 课堂吸收) |

## 脑
| 组件 | 是什么 | 姿态 |
|---|---|---|
| **class-server / PawClass**(+`kb/`) | 学情事实脑:KB·计划·掌握度·练习 | **供弹**(Tapio 唯一依赖交点;内容生产=第二学科弹药) |
| agent-engine(+substrate/constitution/evaluator) | 伙伴决策脑:think/wake/dream | 冷冻,**条件触发例外**:Tapio ≥50 周活时以"跨日决策脑"接入(见 strategy) |

## 平台与运营(全部随主线待命)
| 组件 | 作用 | 姿态 |
|---|---|---|
| api / channel-go / bg-worker / workflows / im-server / modules | ClawBox 主线编排与通道 | 冷冻(agent-engine 复活时一并回温) |
| admin-web(Console)/ evals / CLS / Langfuse | 运营与观测 | 供弹(观测两线共用) |
| infra / K3s 4 节点 | 底座 | 供弹 |
| clawapp / alarm-cli / status-cli / viz-cli / workspace-app(+server) | 容器内 agent 工具层 | 冷冻 |

## 独立线
| 项目 | 判断 |
|---|---|
| TokenGate | 与 K12 无协同——**要么定性为独立小生意单独排时间,要么冷冻;不要和 ClawBox 混在同一个"方向"里消耗心智** |
| agent-skills(本仓) | 方法论,随手维护 |

## 为什么感觉"乱"(诊断,2026-07-03)
1. **V3 宪法是平台愿景宪法,不是资源战法**——"三端原生并进"在单人执行力下=每端半熟。宪法不用推翻,但执行要收敛为"一次只把一个端打穿"。
2. **两套脑哲学并存未分工**:伙伴脑(agent-engine/substrate,开放式陪伴)vs 学情脑(PawClass,结构化教学)。已定分工:学情事实永远住 PawClass;agent-engine 未来只做"决策",不做事实存储。
3. **实验没有毕业机制**:live-board/快慢脑/知识地图都产出过好东西,但实验应"毕业并入主攻线或冷冻",不常驻消耗注意力。live-board 的成果(实时语音+黑板)已在 Tapio 课堂毕业。
4. **跨赛道项目混排**(TokenGate)。

## 收敛战法(90 天,2026-07-03 定)
**所有可支配时间只投 Tapio + PawClass 内容;其余一切冷冻保活;唯一例外 = agent-engine 条件触发。** 冷冻≠放弃:它们是三步走第 3 步(伙伴平台)的资产,Tapio 验证成功后按 strategy 回补。
