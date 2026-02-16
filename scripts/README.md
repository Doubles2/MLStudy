# 가상환경(venv) 가이드 (VS Code + macOS/Windows 공통)

이 README는 아래 3가지를 한 번에 정리합니다.

1. 가상환경 만드는 방법  
2. 가상환경 이름을 바꿨을 때 `.gitignore` 작성법  
3. 가상환경 실행 및 VS Code Kernel 설정 방법  

---

## 1) 가상환경 만드는 방법

> 폴더명이 공백/대괄호를 포함하면 **반드시 따옴표로 감싸서** 실행합니다.

### 1-1) (권장) `bootstrap.sh`로 한 번에 만들기 + 설치하기

**전제**
- 레포 루트: `MLStudy/`
- 레포 루트에 `scripts/bootstrap.sh` 존재
- 강의 폴더 안에 `requirements.txt` 존재

#### 기본(가상환경 폴더명 기본값: `.venv`)
```bash
cd MLStudy
./scripts/bootstrap.sh "[입문_초급] 다양한 예제를 통한 추천 시스템 구현"
```

#### 가상환경 폴더명을 직접 지정(예: `venv`)
```bash
cd MLStudy
./scripts/bootstrap.sh "[입문_초급] 다양한 예제를 통한 추천 시스템 구현" venv
```

> **Windows**에서 위 명령을 그대로 쓰려면 VS Code 터미널을 **Git Bash 또는 WSL(bash)** 로 사용하시는 것을 권장합니다.  
> (PowerShell/CMD에서는 `.sh` 실행이 바로 되지 않습니다.)

---

### 1-2) (수동) 터미널에서 직접 만들기

강의 폴더로 이동해서 생성합니다.

```bash
cd "MLStudy/[입문_초급] 다양한 예제를 통한 추천 시스템 구현"
python -m venv .venv
```

가상환경 폴더명을 바꾸고 싶으면 마지막 인자만 바꿉니다.

```bash
python -m venv venv
python -m venv .venv-recsys
```

#### 활성화(activate)

- macOS/Linux:
```bash
source .venv/bin/activate
```

- Windows (Git Bash 기준):
```bash
source .venv/Scripts/activate
```

#### 패키지 설치
```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

---

## 2) 가상환경 이름을 바꿨을 때 `.gitignore` 작성법

가상환경 폴더는 **절대 커밋하지 않습니다.**  
레포 루트의 `.gitignore`에 아래 중 해당하는 규칙을 추가합니다.

### 2-1) `.venv`를 쓴다면
```gitignore
**/.venv/
```

### 2-2) `venv`를 쓴다면
```gitignore
**/venv/
```

### 2-3) 여러 이름을 쓸 가능성이 있다면(권장: 한 번에 커버)
```gitignore
**/.venv*/
**/venv*/
**/env*/
```

### 2-4) 함께 ignore 하면 좋은 항목(권장)
```gitignore
**/__pycache__/
**/*.pyc
**/.ipynb_checkpoints/
**/.DS_Store
```

---

## 3) 가상환경 실행 & VS Code Kernel 설정

### 3-1) VS Code 인터프리터(Interpreter) 선택

1) VS Code에서 아래 둘 중 하나로 엽니다.
- (권장) 강의 폴더 자체를 열기:  
  `MLStudy/[입문_초급] 다양한 예제를 통한 추천 시스템 구현`
- 또는 MLStudy 루트를 열고 서브폴더로 작업

2) `Cmd/Ctrl + Shift + P` → `Python: Select Interpreter`  
3) 목록에서 아래처럼 **가상환경 경로가 포함된 항목**을 선택합니다.
- `.venv`를 썼다면: `.../.venv/...`
- `venv`를 썼다면: `.../venv/...`

> 한 번 선택하면 보통 해당 워크스페이스에서 기억합니다.

---

### 3-2) 노트북(.ipynb) Kernel 선택

1) `.ipynb` 파일을 엽니다.  
2) 우측 상단 `Select Kernel` 클릭  
3) 3-1에서 선택한 인터프리터와 **동일한 가상환경**을 선택합니다.

---

### 3-3) Kernel 목록에 가상환경이 안 보일 때(해결)

가상환경을 활성화한 뒤 아래를 실행합니다.

```bash
python -m pip install --upgrade pip
pip install ipykernel jupyter
```

그 다음 VS Code에서 Kernel을 다시 선택합니다.