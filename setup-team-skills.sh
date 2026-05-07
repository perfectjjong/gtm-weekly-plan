#!/usr/bin/env bash
set -e

echo ""
echo "=== 팀 스킬 온보딩 설정 ==="
echo ""

# 1. gstack 설치
if [ ! -d "$HOME/.claude/skills/gstack" ]; then
  echo "[1/4] gstack 설치 중..."
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
  cd ~/.claude/skills/gstack && ./setup --team
  cd - > /dev/null
  echo "✅ gstack 설치 완료"
else
  echo "✅ gstack 이미 설치됨 — 업그레이드 중..."
  cd ~/.claude/skills/gstack && git pull --ff-only && ./setup
  cd - > /dev/null
fi

# 2. Matt Pocock 스킬 설치
echo ""
echo "[2/4] Matt Pocock 스킬 설치 중..."
BASE="https://raw.githubusercontent.com/mattpocock/skills/main/skills"
for skill in \
  "engineering/diagnose" \
  "engineering/grill-with-docs" \
  "engineering/improve-codebase-architecture" \
  "engineering/zoom-out" \
  "engineering/setup-matt-pocock-skills" \
  "engineering/triage" \
  "engineering/to-issues" \
  "engineering/to-prd" \
  "engineering/tdd" \
  "engineering/prototype" \
  "productivity/grill-me" \
  "productivity/caveman"; do
  name=$(basename $skill)
  mkdir -p ~/.claude/skills/$name
  curl -fsSL "$BASE/$skill/SKILL.md" > ~/.claude/skills/$name/SKILL.md
  echo "  ✅ $name"
done

# 3. Superpowers 플러그인 (안내만 — 슬래시 커맨드는 Claude Code 내부에서만 실행 가능)
echo ""
echo "[3/4] Superpowers 설치 안내"
echo "  ⚠️  Claude Code 프롬프트에서 아래 두 줄을 직접 입력하세요:"
echo ""
echo "     /plugin marketplace add obra/superpowers-marketplace"
echo "     /plugin install superpowers@superpowers-marketplace"
echo ""

# 4. 설치 확인
echo "[4/4] 설치 확인 중..."
SKILLS=$(ls ~/.claude/skills/ | wc -l)
echo "  설치된 스킬 디렉토리: ${SKILLS}개"

echo ""
echo "=============================="
echo "✅ 온보딩 완료!"
echo ""
echo "Claude Code 재시작 후 /reload-plugins 입력하시면 모든 스킬이 활성화됩니다."
echo "=============================="
echo ""
