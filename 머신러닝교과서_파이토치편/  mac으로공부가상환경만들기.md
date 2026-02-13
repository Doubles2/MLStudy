# macOS에서 VS Code + PyTorch(torch) 가상환경(venv) 세팅 가이드

이 문서는 macOS에서 **프로젝트별 Python venv를 만들고**, 그 환경에 **torch/torchvision 등 패키지를 설치한 뒤**,  
**VS Code에서 인터프리터/주피터 커널까지 정상 연결**하는 과정을 한 번에 정리한 것입니다.

- 예시 경로: `/Users/soonwon/code/MLStudy`

---

## 0) 전제 조건

### VS Code 확장(필수)
- **Python** (ms-python.python)
- **Jupyter** (ms-toolsai.jupyter)

> VS Code에서 커널 목록/주피터 관련 메뉴가 안 보이면, 대부분 확장 미설치/비활성 또는 워크스페이스 Trust 문제입니다.

---

## 1) 프로젝트 폴더 준비

```bash
mkdir -p /Users/soonwon/code/MLStudy
cd /Users/soonwon/code/MLStudy
```

---

## 2) 가상환경(venv) 생성

프로젝트 폴더 안에 `.torch_study`라는 venv를 생성합니다.

```bash
cd /Users/soonwon/code/MLStudy
python3 -m venv .torch_study
```

가상환경 파이썬 경로 확인:

```bash
ls -la .torch_study/bin/python
```

---

## 3) requirements.txt 작성

`numpy, pandas, matplotlib, torch, torchvision` + (노트북용) `ipykernel`까지 포함합니다.

```bash
cd /Users/soonwon/code/MLStudy

cat > requirements.txt << 'EOF'
numpy
pandas
matplotlib
torch
torchvision
ipykernel
EOF
```

---

## 4) 패키지 설치 (중요: venv python으로 설치)

**항상 `./.torch_study/bin/python -m pip ...` 형태로 설치**합니다.  
(그래야 pyenv/시스템 파이썬과 섞이지 않습니다.)

```bash
cd /Users/soonwon/code/MLStudy

./.torch_study/bin/python -m pip install -U pip
./.torch_study/bin/python -m pip install -r requirements.txt
```

---

## 5) (선택) 터미널에서 torch 설치 확인

```bash
cd /Users/soonwon/code/MLStudy

./.torch_study/bin/python -c "import sys, torch; print(sys.executable); print(torch.__version__)"
```

- `sys.executable`이 반드시 아래처럼 venv 경로여야 합니다.
  - `/Users/soonwon/code/MLStudy/.torch_study/bin/python`

---

## 6) Jupyter 커널 등록 (노트북용)

노트북(.ipynb)에서 커널 선택 목록에 뜨게 하려면 커널 등록이 필요합니다.

```bash
cd /Users/soonwon/code/MLStudy

./.torch_study/bin/python -m ipykernel install --user --name torch-study --display-name "Python (torch-study)"
```

등록 확인:

```bash
jupyter kernelspec list
```

커널 설정 파일 확인(원인 분석 시 유용):

```bash
cat /Users/soonwon/Library/Jupyter/kernels/torch-study/kernel.json
```

여기 `"argv"` 첫 값이 venv python을 가리켜야 정상입니다:

```json
"/Users/soonwon/code/MLStudy/.torch_study/bin/python"
```

---

## 7) VS Code에서 인터프리터 연결

1. VS Code에서 프로젝트 폴더(`MLStudy/`)를 엽니다.
2. `⇧⌘P` (Command Palette) 실행
3. **Python: Select Interpreter** 선택
4. 아래 인터프리터를 선택합니다.

- `/Users/soonwon/code/MLStudy/.torch_study/bin/python`

목록에 보이지 않으면:
- **Enter interpreter path...** 를 선택해서 위 경로를 직접 지정합니다.

---

## 8) VS Code에서 노트북 커널 선택

1. `.ipynb` 파일을 엽니다.
2. 오른쪽 위 **Select Kernel** 클릭
3. **Python (torch-study)** 선택

노트북 셀에서 최종 확인:

```python
import sys, torch
print(sys.executable)
print(torch.__version__)
```

- `sys.executable`이 `.torch_study/bin/python`이면 성공입니다.

---