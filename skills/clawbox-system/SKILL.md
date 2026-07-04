---
name: clawbox-system
description: ClawBox 产品体系总纲——使命→发展路线→产品矩阵→项目理解→部署→查问题的完整链条,加跨会话迭代仪式。做产品方向决策、跨项目协调、新会话接手任何产品线、或"我们下一步该做什么"时先读。
---

# clawbox-system — 从使命到查问题的一条链

> 本文件就是主轴:六环各给**结论**,细节在链接的深文件里。任何会话按此链自上而下对齐,再按底部仪式干活。

## ① 使命
每个孩子拥有一个**有形象、有性格、记得住你**的 AI 伙伴,陪他学习和成长——"永远在线的学长",不是问答工具。(全文与决策记录 → `strategy.md`)

## ② 发展路线(2026-07-03 拍板)
**三步走:Tapio 单点破局 → PawClass 大脑复利 → ClawBox 伙伴平台。**
90 天战法:只投 Tapio+PawClass,其余全线冷冻保活。agent-engine 以 **Echo Brain 三步长成**兑现("常驻大脑=一个服务里的 N 个心智,不是 N 个容器";**①②已上线生产**——tapio-brain 服务借引擎心智内核,每学习者一个记忆目录,夜跑=真 dream turn;②的主动性 APNs 部分待做/③≥50 周活与 ClawBox 部署形态合流)。demo→产品作战计划(北极星=10 个孩子每周回来)→ `roadmap.md`;完整论证 → `strategy.md`。

## ③ 产品矩阵
嘴×脑×底座:**Tapio iOS+Android/SDK(主攻;安卓 2026-07-04 照 iOS 全量复刻并打成可嵌入 SDK `ai.tapio:tapio-sdk`)** · tapio-brain(常驻心智服务,生产) · PawClass/class-server(供弹) · ClawBox 三端 iOS/Clawdy/im-web(冷冻) · agent-engine(冷冻,Echo Brain 条件复活) · Console/infra(供弹) · TokenGate(独立,待定性)。全量 21 packages+3 外部仓逐个姿态与"为什么乱"的四条诊断 → `portfolio.md`。

## ④ 项目理解(每线一句话 + 深度认知入口)
- **Tapio**:嘴=iOS(SwiftUI+Gemini Live)+Android/SDK(Kotlin+Compose,`apps/android`,公共 API 仅 TapioSdk)+Hono server;脑=PawClass(delegation JWT,userId==studentId)+tapio-brain(心智档案/夜间 dream);V3 私人外教全流程已上机,TestFlight 可分发。深度 → Claude memory `project_tapio_learning_engine` + Tapio 仓 `apps/server/scripts/voice-e2e/README.md`。
- **ClawBox 主线**:OpenIM 消息面 + Temporal/Coder 控制面 + agent-engine(think/wake/dream)+ PawClass。深度 → clawbox 仓本地 skill `.claude/skills/clawbox/`(唯一深度真相源)。
- **TokenGate**:多模态 API 网关。深度 → `~/Ideas/tokengate` + memory `project_tokengate`。
- 每线状态/未决事项 → `portfolio.md` 的一页纸。

## ⑤ 部署
Tapio:rsync→docker build/push GHCR→kubectl rollout(server+brain);xcodebuild+devicectl(真机)/release-ios.sh+altool(TestFlight);Android=gradle assembleRelease/publishToMavenLocal(SOP → runbook)。ClawBox:4 条 CI。**完整 SOP 与命令 → `runbook.md`**。铁律:必须 push GHCR,不能只 build。

## ⑥ 查问题
先 `curl https://tapio.teachclaw.app/healthz`;Tapio 回归=voice-e2e、数据=pg pod `postgres-0`、视觉 QA=`-qaToken/-qaScreen`、日报=`daily-stats.mjs`;ClawBox=cls-logs / agent-trace-debug skills。**全部入口与踩坑 → `runbook.md`**。

## 迭代仪式(靠它"系统不断迭代")
1. **开工**:curl healthz(非 200 = 最高优先级)→ 读 `progress.md`(30 秒恢复状态)。
2. **对齐**:动方向先过 ②③;动某条线先过 ④ 的认知入口。
3. **干活**:按 `roadmap.md` 当前阶段取最高价值项;新任务先问"是 Tapio/PawClass 吗?"不是则默认拒绝/最小化。
4. **收工**:状态写回 `progress.md`;方向变化改 `strategy.md`(带日期);链条内容变了,**回来同步本文件的对应环**。
5. 纪律:每篇 ≤100 行;深度内容下沉项目层,本 skill 只留结论与索引。
