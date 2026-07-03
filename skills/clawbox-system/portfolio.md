# portfolio — 产品矩阵与每条线一页纸

## 矩阵(嘴 × 脑 × 底座)
| 层 | 产品/组件 | 状态 | 仓库 |
|---|---|---|---|
| 嘴(交互) | **Tapio iOS**(K12 英语私教) | ✅ 主战场,V3 全流程上机 | github.com/mrzch03/Tapio |
| 嘴 | ClawBox iOS(伙伴 App:Live2D/语音/学习面板) | 可用,35 测试通过 | clawbox 仓 packages |
| 嘴 | Clawdy 桌宠(Tauri v2) | 全功能可用 | clawbox 仓 |
| 嘴 | im-web(含 live-board-lab 实时黑板) | 实验层 | clawbox 仓 |
| 脑(事实) | **PawClass / class-server**(KB·计划·掌握度·讲义) | ✅ 两线共享大脑 | clawbox 仓 |
| 脑(决策) | agent-engine(think/wake/dream) | ClawBox 主线在用;Tapio 待 M2 接入(见 strategy) | clawbox 仓 |
| 底座 | K3s 4 节点·4 条 CI·CLS 日志·Langfuse | 运行中 | — |
| 底座 | TokenGate(多模态 API 网关) | 独立线 | ~/Ideas/tokengate |
| 方法论 | agent-skills(本仓) | 持续维护 | github.com/mrzch03/agent-skills |

## 每条线一页纸
### Tapio(主战场)
- **是什么**:嘴=iOS(SwiftUI+Gemini Live 语音)+ Hono server;脑=PawClass(delegation JWT 耦合,Tapio userId==studentId)。
- **已上机**:初见语音定级→自动排课→对话课堂(黑板卡/讲义)→场景作业→小关闯关/通关→计划页;会员制+兜底 60 轮/天;断线重连+缓冲;PTT pre/post-roll。
- **深度认知入口**:Claude memory `project_tapio_learning_engine`(全史)+ Tapio 仓 `apps/server/scripts/voice-e2e/README.md`(回归)。
- **未决**:真机手感终验、教育备案、IAP(占位)、发音评测选型。

### ClawBox 主线
- **是什么**:个人 Agent 伙伴平台(多端 + agent-engine + PawClass + Console)。
- **深度认知入口**:clawbox 仓本地 skill `.claude/skills/clawbox/`(唯一深度真相源,未入 git)+ CLAUDE.md(愿景+12 铁律)。
- **当前姿态**:为 Tapio 供大脑;主线体验迭代降速让位单点破局。

### TokenGate
- 多模态 API 网关,独立演进;认知入口 `~/Ideas/tokengate` + memory `project_tokengate`。
