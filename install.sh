#!/usr/bin/env bash
# 把本仓的 skill 软链进目标 skills 目录(默认 ~/.claude/skills)。
# 软链 = 一份物理、git pull 即更新、不复制不漂移。幂等:已存在的同名链接会被覆盖。
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:-$HOME/.claude/skills}"

mkdir -p "$DEST"
echo "安装目标: $DEST"
for d in "$REPO"/skills/*/; do
  name="$(basename "$d")"
  link="$DEST/$name"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "  跳过 $name(目标已存在且不是软链,未覆盖以防误删)"
    continue
  fi
  ln -sfn "$d" "$link"
  echo "  链接 $name → $d"
done
echo "完成。装了: $(ls -1 "$REPO"/skills | tr '\n' ' ')"
