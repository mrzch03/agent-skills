# progress — 体系账本(每次会话收工更新)

> 2026-07-03 初始化。

## 进行中
- **Echo Brain ② Phase A 开工**(2026-07-04 凌晨,clawbox issue #226):方向=创始人拍板("认识孩子要基于 agent 系统");形态=tapio-brain service(clawbox monorepo 新包,workspace 引 agent-engine 心智内核,每学习者一个目录,内部 HTTP 供 tapio-server 调)。**A1 已合并(PR #227)**:exports 导出 + 骨架 + import smoke 实证(runAgent+9 specs 容器外干净加载)。**A2 PASS(PR #235 已合并)**:真 dream turn 容器外 19.8s 跑通(读转写→档案更新带日期合入→归档→回显)。排障皇冠:**claude 二进制在 root 下拒绝 bypassPermissions 且静默退出码 1——brain service 容器必须非 root**。下一步 A3:服务化(Dockerfile 非root/K3s/专用 secret)+ tapio-server 切调用。
- **真实链路首次复盘完成**(2026-07-04 凌晨):核心教学闭环生产验证✓(三单纠错→跟我读→产出);修了 2 个 prompt 问题(凭空夸奖/超范围承诺日语课,`f6b479c`)+ 纠错 15.4s(无上限 thinking,加 4096 cap);**首次生产夜跑成功(7/4 03:30):2/2 档案更新含真实账号**,日语线头/开口状态/三个下次课话头全进档案;下次 chat 将 notes=yes。精修已上线(Tapio `a994213`):roleplay/homework 转写打标 [角色扮演] + prompt 规则(台词≠生活事实,开口状态可观察);51 测试过,已部署。明晚夜跑观察 Alex 假名是否被清出档案。
- **KB 素材线**(2026-07-03 下午,两轮):① 发现并版本化生产 PVC 知识库(41 概念/全册 syllabus,此前唯一副本无备份;仓库只有 9 概念过时种子)→ clawbox PR #224,同步 SOP 在 `kb/README.md`。② 充实 4 个薄概念(comparative-adjectives/exclamatory-sentences/some-in-questions/whom-usage)→ 同 PR。③ **按真实学情打磨最弱 3 概念**(concept_mastery 07-02:be-verb 5练4错 / personal-pronouns 3/3错 / yes-no-questions 2/2错):这些文件不薄但由增量追加长成,整条重复的 bullet 挤占 Tapio 只抽前 4/3/4 条的头部槽位,例句混教材对话残留(M:/W:)→ 全文去重重排,PR #225 已合并,PVC 已推,tapio 已重启。**经验:KB 文件"厚"≠"能用",头部槽位质量才是私教课底料质量;agent 增量追加会长出重复,新素材过一遍抽取窗口检查。** 剩余薄文件多为技能型概念(阅读/写作/翻译),语音课很少命中,低优先级。
- **用户真实账号 = `usr_OoDYgPXMB_YT`**(apple 登录);7/2 真机会话已给 12 个概念写回学情,学情回流链路(correction→concept_mastery)实测在工作。查学情:`kubectl exec -n clawbox postgres-0 -- psql -U clawbox -d pawclass -c "SELECT ... FROM concept_mastery WHERE user_id='usr_OoDYgPXMB_YT'"`。
- **nightly dream 首跑已验证**(07-04 03:32 生产):sweep 2/2 档案更新;真实账号 10 行转写→302 字符档案,质量达标(兴趣含日语诉求/名字 Alex/学习状态/3 条下次课线头,零学情越界)。与语言门控正确分工:同一句中文日语诉求,学情侧被门控挡住、心智侧被 dream 记住。剩「chat 注入 notes=yes」待下次真机会话验。
- **Echo Brain ① 已上线**(2026-07-03):session_transcripts + learner_notes + nightly dream(北京03:30)+ 课堂注入。生产 e2e 验证:档案质量真实(兴趣/带日期近况/状态/线头,零学情越界),"上次篮球赛赢了几分?"进课堂 prompt。下一步:真实学生数据观察一周,再进 ②(APNs+常驻主动性)。
- **90 天收敛战法执行中**(2026-07-03 用户拍板):只投 Tapio+PawClass;其余冷冻保活;agent-engine ≥50 周活触发。每次会话按此分配时间。
- Tapio:等用户真机走"初见+一节课"终验(PTT 手感/黑板时机/等级准确度)。
- **crash 采集已上线**(2026-07-03 晚,Tapio `97b99ac`):iOS MetricKit CrashReporter + POST /metrics/diagnostics + client_diagnostics 表(JSONB,人读)。45 测试过,已部署,等下一次真机安装生效。查询:`SELECT kind, app_version, created_at FROM client_diagnostics`。
- **TestFlight 已上传**(2026-07-03 晚):ASC App record 建好(App ID 6787105369)→ 1.0(1) `Upload succeeded`(含 CrashReporter)。等 Apple 处理后用户在 TestFlight 页答一次出口合规(仅这包;`ITSAppUsesNonExemptEncryption=NO` 已进工程)+ 建内部测试组。上传命令:`xcodebuild -exportArchive -archivePath /tmp/tapio-release/Tapio.xcarchive -exportOptionsPlist /tmp/tapio-release/uploadOptions.plist -allowProvisioningUpdates`(先跑 scripts/release-ios.sh 归档)。
- **真机反馈两连修**(2026-07-03 晚,Tapio `4450e65`+`a419e7a`):①语音条去 ASR 中间态——按下即"录音中"胶囊,松手~450ms 可回放,ASR 文字只作纠错 key 不展示;②首页 mic pill 直进 live 自由聊(新 kind 'chat',镜像 meet 的零压力语义,notes 注入,不进场景库,喂 dream);删 VoiceCreateOverlay+SpeechRecognizer 死代码。服务端已部署,真机等安装(重试循环挂着)。
- 教育备案:未启动,是正式上线最长杆——需尽早。

- **07-04 凌晨 loop 会话(与 Echo Brain ② 会话并行)**:①写回**语言门控**修+部署——中文句曾被 credit 为 modal-verbs;生产 12 句回归:误报 0/5、召回 3/3、门控泄漏 0/3(纯中文 ms=0 零 API 调用)。②**writeback_audit 落表**+日报带写回分布(分布复核不再依赖易失 pod 日志)。③agent-engine 热修(因 #226 用它当心智内核而升级为主线相关):PR #229 think 退避计数恒 0 的 P0+tsc 进 CI(codex 两轮 APPROVE,已 rebase 上 #227,待合)、PR #231 安全闸 34 单测+堵无 flag rm 漏拦洞(待合)、P1 留案 #232(前缀路由漂移吞话)/#233(超时不 abort+crash 循环)。

## 待验证
- Gemini Live preview 模型坏窗口频率(重连+缓冲护栏已上,真实用户侧观测中)。
- 会员制转化:兜底 60 轮/天是否足以既留人又促升级。

## 已排除 / 已决策(近期)
- 积分经济 ✗(2026-07-03 用户拍板废除,会员制+兜底取代)。
- ASR 口音问题 ✗(中式口音实测 5/5,真因是 quota 杀会话+PTT 首尾裁切,均已修)。
- agent-engine 现在接入 ✗ → 定为 M2(≥50 周活触发,见 strategy.md)。
