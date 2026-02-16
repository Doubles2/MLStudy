#!/usr/bin/env bash
set -euo pipefail

# 사용법:
#   ./scripts/bootstrap.sh "<대상폴더경로>" [가상환경폴더명]
#
# 예)
#   ./scripts/bootstrap.sh "[입문_초급] 다양한 예제를 통한 추천 시스템 구현"
#   ./scripts/bootstrap.sh "[입문_초급] 다양한 예제를 통한 추천 시스템 구현" venv
#   ./scripts/bootstrap.sh "[입문_초급] 다양한 예제를 통한 추천 시스템 구현" .venv-recsys

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-}"
VENV_DIR="${2:-.venv}"

if [ -z "$TARGET_DIR" ]; then
  echo "[ERROR] 대상 폴더를 인자로 주세요."
  echo "  예: ./scripts/bootstrap.sh \"[입문_초급] 다양한 예제를 통한 추천 시스템 구현\""
  exit 1
fi

cd "$PROJECT_ROOT/$TARGET_DIR"

# python 커맨드 결정 (macOS/Linux/Windows Git Bash 모두 대응)
PYTHON=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON="python"
else
  echo "[ERROR] python(또는 python3)가 없습니다."
  exit 1
fi

if [ ! -f "requirements.txt" ]; then
  echo "[ERROR] $(pwd)에 requirements.txt가 없습니다."
  exit 1
fi

# 1) venv 생성
if [ ! -d "$VENV_DIR" ]; then
  echo "[INFO] Creating venv in $(pwd)/$VENV_DIR"
  "$PYTHON" -m venv "$VENV_DIR"
fi

# 2) venv 활성화 (macOS/Linux: bin, Windows: Scripts)
if [ -f "$VENV_DIR/bin/activate" ]; then
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
elif [ -f "$VENV_DIR/Scripts/activate" ]; then
  # Git Bash / MSYS 환경에서 Windows venv 활성화
  # shellcheck disable=SC1091
  source "$VENV_DIR/Scripts/activate"
else
  echo "[ERROR] venv activate 스크립트를 찾지 못했습니다."
  echo " - 기대 경로: $VENV_DIR/bin/activate 또는 $VENV_DIR/Scripts/activate"
  exit 1
fi

# 3) requirements.txt 해시(sha256)를 파이썬으로 계산 (OS 무관)
REQ_HASH="$("$PYTHON" - <<'PY'
import hashlib
p="requirements.txt"
data=open(p,"rb").read()
print(hashlib.sha256(data).hexdigest())
PY
)"

HASH_FILE="$VENV_DIR/.requirements.sha256"
PREV_HASH=""
if [ -f "$HASH_FILE" ]; then
  PREV_HASH="$(cat "$HASH_FILE")"
fi

python -m pip install --upgrade pip

if [ "$REQ_HASH" != "$PREV_HASH" ]; then
  echo "[INFO] Installing dependencies..."
  pip install -r requirements.txt
  echo "$REQ_HASH" > "$HASH_FILE"
else
  echo "[INFO] Requirements unchanged. Skipping install."
fi

echo ""
echo "[DONE] Environment ready: $(pwd)"
echo " - VENV_DIR:         $VENV_DIR"
echo " - Activate (mac):   source $VENV_DIR/bin/activate"
echo " - Activate (win):   source $VENV_DIR/Scripts/activate"
echo " - Jupyter:          jupyter lab"
