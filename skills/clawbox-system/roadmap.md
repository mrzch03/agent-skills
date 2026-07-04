# roadmap — Demo → 产品作战计划(2026-07-03,负责人视角)

**北极星:第一批 10 个真实孩子,每周都回来上课。** 在此之前,一切以"能给别人用+能看见他们怎么用+他们愿意回来"为纲。

## 差距诚实清单(demo 与产品之间)
分发(~~无 TestFlight~~ iOS TestFlight 已通/Android APK+SDK 已出)· 反馈闭环(无崩溃上报/行为漏斗/反馈入口)· 值守(服务挂了没人知道)· 记忆(Echo 不记得孩子,只有学情数据)· 内容(一册书 ~9 关)· 收款(IAP 占位)· 合规(备案未启动)· 增长(零)。

## 阶段 0 · 能给别人(本周)
- [x] TestFlight(2026-07-04):ASC App record 建好(App ID 6787105369)+ build 1/2 已上传(build 2 含全部修复;上传走 altool 通道);剩用户侧一次合规确认+建内部测试组
- [x] `/healthz` 端点 + 循环值守(每小时探活+关键指标,见 SKILL.md 迭代仪式)
- [x] 崩溃采集(2026-07-03/04):iOS MetricKit CrashReporter + Android uncaught/ANR 上报 → /metrics/diagnostics 落库(client_diagnostics 表)
- [ ] 备案启动(**用户动作**:法务/资质材料)

## 阶段 1 · 别人用得好(2-4 周,种子期)
- [ ] 种子用户 5-10 个(朋友的孩子),建反馈微信群
- [x] **Echo Brain ①**(2026-07-03 上线):transcripts+learner_notes+nightly dream+课堂注入,生产 e2e 验证通过
- [x] App 内反馈入口(2026-07-03):Profile'反馈与建议'行,mailto 带机型/版本,已装机
- [x] 日报脚本(2026-07-03):`apps/server/scripts/daily-stats.mjs`,首份数据:近24h 学习者2/会话6/开口22轮/dream档案1
- [ ] 按反馈快修循环(体验问题 48h 内响应)

## 阶段 2 · 愿意留下+可持续(4-8 周)
- [ ] 留存机制:APNs 推送(主动关怀的前置基建)+ 家长周报
- [ ] 内容扩册:人教七下(KB 生产管道复用)
- [ ] IAP 真收款(StoreKit 2,需用户在 App Store Connect 建产品)
- [ ] 发音评测选型(品类硬线)
- 检查点:D7 留存 ≥40%、周均课次 ≥3 → 达标才谈增长投放

## Echo Brain — 常驻 agent 外教大脑(2026-07-03 定;**①② 心智服务已生产运行 2026-07-04**,余②主动性/APNs)
**"常驻大脑"从第一天就是产品架构的名字;但它是"一个常驻服务里的 N 个心智",不是"N 个容器"。** 此前的顾虑真正针对的是 agent-engine 的 per-user 容器形态,不是"常驻"本身。三步长成:
1. **①种子期(阶段1)**:nightly dream job(Tapio server 内):每晚复盘每个学生当日会话 → 更新心智档案 `learner_notes`(学情之外的"这个孩子":喜欢篮球/下周考试/怕背单词)→ 调明日课;课堂 prompt 注入。交付"被记得"(开场提到他的猫/他的比赛)——留住前 10 个孩子的钩子。零新服务,一晚一次调用。
2. **②借 agent-engine 心智内核,host 成多租户 brain service(2026-07-04 方案定稿,创始人拍板推进)**。
   探查实锤(agent-engine 源码级):引擎现形态="大脑焊死在身体上"——每学习者一个桌面级 Coder 容器+OpenIM 身份,触发面全是 IM 消息形状,**不可直接接入**;但心智内核可剥离——`runAgent(chatId, prompt, {cwd, mode, systemPromptAppend})` 只需要一个目录就能跑(evals/agent-core/live-adapter.ts 是无容器/无IM/无Temporal运行的现成先例),think/wake/dream 是模式规范不是代码层(substrate/mode-specs.ts),记忆是 `.learner/` 文件约定。
   **方案:Tapio brain service = runAgent + mode-specs + .learner/ 约定,每学习者一个目录(PVC),不是一个容器。**
   - Phase A(心智内核移植,~2-3 天):agent-engine 补导出 runAgent/composeTurn(铁律4:补包导出,不复制代码);`/data/minds/<userId>/.learner/` 三层记忆(MEMORY.md/profile/journal/todo);现有 nightly dream 从单次 Flash 重写升级为真 dream turn(带 Read/Write/Bash 限定目录 + class CLI 查学情)→ 产出 learner_notes(注入接口不变)+ 计划调整 + 家长周报草稿。触发=tapio-server 直调,零 IM 零 Temporal(两条 workflow 都不碰,无 patched() 风险)。
   - Phase B(主动性,+2-3 天):alarms 表(tapio DB)+ 调度器 → wake turns → APNs push(证书+iOS 注册是独立工作量)。三天没来会想你/考前提醒——Echo 在孩子不在时也活着。
   - Phase C:Langfuse 观测 + eval harness 复用。
   - 纪律:Node ESM(bun≠node 教训);单心智单飞行;每 turn 预算上限;内部调用走 service 层不走 header 自声明(engine 的 alarm API X-Agent-IM-User-ID 是反面教材勿抄);LLM 走 MiniMax relay(composer 已做前缀缓存优化)。
3. **③≥50 周活**:与 ClawBox 部署形态真正合流(共享 substrate 演进/评估体系)——平台资产变现,ClawBox 主线复活之桥。
成本:每学习者=磁盘一个目录+每天几次 SDK 调用(比单次 Flash 贵,但零常驻容器);100 学生≈1 个 service pod。
产品叙事随之升级:**"每个孩子有一位 24 小时活着的 AI 外教,她真的认识你。"**
