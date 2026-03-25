#!/usr/bin/env bash
set -euo pipefail

# 사용법:
#   ./scripts/bootstrap.sh "<대상폴더경로>" [가상환경폴더명] [extra]
#
# 예)
#   ./scripts/bootstrap.sh "머신러닝교과서_파이토치편" pyml-book torch
#   ./scripts/bootstrap.sh "다른프로젝트" .venv
#
# extra 지원값:
#   torch   -> torch / torchvision 설치

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-}"
VENV_DIR="${2:-.venv}"
EXTRA="${3:-}"

TORCH_VERSION="2.5.1"
TORCHVISION_VERSION="0.20.1"

if [ -z "$TARGET_DIR" ]; then
  echo "[ERROR] 대상 폴더를 인자로 주세요."
  echo '  예: ./scripts/bootstrap.sh "머신러닝교과서_파이토치편" pyml-book torch'
  exit 1
fi

cd "$PROJECT_ROOT/$TARGET_DIR"

PYTHON=""
if command -v python3.9 >/dev/null 2>&1; then
  PYTHON="python3.9"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON="python"
else
  echo "[ERROR] python3.9 / python3 / python 이 없습니다."
  exit 1
fi

echo "[INFO] Using Python: $PYTHON"
"$PYTHON" --version

if [ ! -f "requirements.txt" ]; then
  echo "[ERROR] $(pwd)에 requirements.txt가 없습니다."
  exit 1
fi

# 1) venv 생성
if [ ! -d "$VENV_DIR" ]; then
  echo "[INFO] Creating venv in $(pwd)/$VENV_DIR"
  "$PYTHON" -m venv "$VENV_DIR"
fi

# 2) venv 활성화
if [ -f "$VENV_DIR/bin/activate" ]; then
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
elif [ -f "$VENV_DIR/Scripts/activate" ]; then
  # shellcheck disable=SC1091
  source "$VENV_DIR/Scripts/activate"
else
  echo "[ERROR] venv activate 스크립트를 찾지 못했습니다."
  exit 1
fi

# 3) pip 기본 업그레이드
python -m pip install --upgrade pip setuptools wheel

# 4) requirements 설치
echo "[INFO] Installing requirements.txt ..."
python -m pip install -r requirements.txt

# 5) extra 설치
if [ "$EXTRA" = "torch" ]; then
  echo "[INFO] Installing torch extras ..."
  python -m pip install "torch==${TORCH_VERSION}" "torchvision==${TORCHVISION_VERSION}"
fi

# 6) jupyter/ipykernel 설치
python -m pip install ipykernel jupyterlab

# 7) 커널 등록
KERNEL_NAME="$VENV_DIR"
KERNEL_DISPLAY_NAME="Python ($VENV_DIR)"

echo "[INFO] Registering kernel: $KERNEL_NAME"
python -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_DISPLAY_NAME"

# 8) 확인용 출력
echo ""
echo "[INFO] Python executable:"
python -c "import sys; print(sys.executable)"

echo ""
echo "[INFO] Jupyter paths:"
jupyter --paths

echo ""
echo "[INFO] Installed kernels:"
jupyter kernelspec list

echo ""
echo "[DONE] Environment ready"
echo " - project:        $(pwd)"
echo " - venv:           $VENV_DIR"
echo " - kernel name:    $KERNEL_NAME"
echo " - display name:   $KERNEL_DISPLAY_NAME"
echo " - activate:       source $VENV_DIR/bin/activate"
echo " - open jupyter:   jupyter lab"