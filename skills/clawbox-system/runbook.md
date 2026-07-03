# runbook — 部署 SOP 与查问题入口(按线)

## Tapio
### 部署 server(生产 = K3s ns `tapio`)
```bash
# /root/tapio 不是 git 仓,以本地 main 为源 rsync
rsync -az --delete -e "ssh -i ~/.ssh/new.pem" \
  --exclude='.git' --exclude='node_modules' --exclude='apps/ios' --exclude='apps/android' \
  --exclude='docs' --exclude='.claude' --exclude='dist' \
  ~/Ideas/Tapio/ root@43.131.234.2:/root/tapio/
ssh -i ~/.ssh/new.pem root@43.131.234.2 'cd /root/tapio \
  && docker build -q -f apps/server/Dockerfile -t ghcr.io/mrzch03/tapio-server:latest . \
  && docker push -q ghcr.io/mrzch03/tapio-server:latest \
  && kubectl rollout restart deployment/tapio-server -n tapio \
  && kubectl rollout status deployment/tapio-server -n tapio --timeout=150s'
```
### 部署 iOS(真机 = 张志强的 iPhone)
```bash
cd ~/Ideas/Tapio/apps/ios/Tapio
xcodebuild -project Tapio.xcodeproj -scheme Tapio -configuration Debug \
  -destination "generic/platform=iOS" -derivedDataPath /tmp/tapio-dev -allowProvisioningUpdates build
xcrun devicectl device install app --device 00008150-001D1931367A401C \
  /tmp/tapio-dev/Build/Products/Debug-iphoneos/Tapio.app
# 设备锁屏/离线 → 循环重试(150s 间隔),上线即装
```
### 查问题
- **全链路回归**:`apps/server/scripts/voice-e2e/`(合成语音 e2e,README 含全部踩坑)。
- **看用户说了什么/写回**:`kubectl logs -n tapio <pod> | grep writeback`(pod 滚动只留两代,及时抓)。
- **模拟器视觉 QA**:DEBUG 启动参数 `-qaToken <jwt> -qaApiBase <url> -qaScreen plan|map|profile`;token 在 pod 内 `signSessionJWT(uid)` 铸;测试用户必须插 users+points+**memberships** 三行,provider 必须是 email/phone/apple。
- 数据库:pg pod `postgres-0` ns clawbox,DB `tapio`(用户/额度/讲义)与 `pawclass`(学情),用户 `clawbox`。

## ClawBox 主线
- **部署**:4 条 CI(push 触发;class-server 走 deploy-class.yml);详见 clawbox 本地 skill `workflow/verify-and-deploy.md`。
- **查问题**:CLS 日志(Seoul,5 服务统一 JSON,用 `cls-logs` skill);agent turn 排障用 `agent-trace-debug` skill(turn_id 串 Langfuse+PG+CLS);K3s 节点怪癖(ip_forward 等)见 memory。

## 通用
- 凭据一律 memory `secrets.md` / clawbox 仓 `plan.md §十二`,不进任何 skill。
- 生产改动必须 push GHCR(不能只本地 build)——历史事故教训。
