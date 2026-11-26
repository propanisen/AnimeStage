# AnimeStage

**KDE Plasma 6 데스크톱을 좋아하는 애니메이션 분위기로.**
애니메이션 제목만 입력하면 AnimeStage가 그 작품에 맞춰 데스크톱 전체를 꾸며 줍니다. 바뀌는 배경화면, 어디서나 어울리는 색상, 시작 메뉴 속 캐릭터, 그리고 터미널·Firefox·VS Code까지 같은 스타일로.

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · **한국어**

![프리렌 배경화면과 AnimeStage 패널이 있는 데스크톱](screenshots/desktop.jpg)

## 기능

- **어떤 애니메이션이든**: AniList로 검색하면 제목, 배너, 캐릭터(나이 포함)를 자동으로 가져옵니다.
- **바뀌는 배경화면**: 2시간마다(조절 가능) Konachan에서 새 이미지를 받아 오며, 캐릭터·필터·분위기로 고를 수 있습니다. 마음에 드는 이미지는 즐겨찾기에, 안 맞는 이미지는 제외할 수 있습니다.
- **배경화면을 따라가는 색상**: 새 이미지마다 강조색을 뽑아 Plasma, 창 장식, 폴더 아이콘(Papirus), 터미널, Firefox, VS Code에 적용합니다.
- **애니메이션 스타일 패널**: 캐릭터가 있는 시작 메뉴, Windows처럼 창 이름이 보이는 작업 표시줄, 음악 플레이어, CPU/RAM/GPU 링, 캘린더.
- **터미널**: 테마 색상의 kitty 또는 Konsole, 새 이미지와 시스템 정보가 나오는 인사말, Starship 프롬프트, 원하면 배경 이미지도.
- **Firefox**: 탭과 주소 표시줄을 어울리는 색으로 바꾸고, 시작할 때마다 새 탭 이미지가 바뀝니다.
- **잠금 화면과 로그인 화면**에도 같은 배경화면이 나옵니다(로그인: Plasma Login Manager).
- **제어 센터**: 모든 설정을 한 창에서 할 수 있어 설정 파일을 건드릴 필요가 없습니다.
- **13개 언어**: 시스템 언어를 따르고, 제어 센터에서 바꿀 수 있습니다.

### Windows 같은 작업 표시줄

![창 이름이 보이는 작업 표시줄](screenshots/taskbar.png)

창마다 아이콘 옆에 이름이 붙은 버튼이 따로 생깁니다. Firefox 창이 두 개면 버튼도 두 개입니다. 고정한 앱은 놓은 자리에 그대로 있고, 창도 그 자리에서 열립니다. **제어 센터 → 모양 → 작업 표시줄**에서 이름 숨기기, 창 묶기, 너비(좁게 / 보통 / 넓게)를 설정할 수 있습니다.

### 배경화면과 색상

![배경화면 세 장과 AnimeStage가 각각에서 뽑은 색상](screenshots/wallpapers.jpg)

새 배경화면마다 색상도 함께 바뀝니다. AnimeStage가 이미지에서 강조색과 배경색을 뽑아 패널, 창, 아이콘, 터미널, Firefox, VS Code를 다시 칠합니다 – 2시간마다 자동으로. 각 그림 아래쪽 패널은 바로 그 이미지에서 뽑은 색상입니다.

### 시작 메뉴, 캘린더, 시스템 부하

![AnimeStage: 시작 메뉴, 캘린더, 시스템 부하](screenshots/preview.png)

| 제어 센터 – 애니메이션과 캐릭터 | 제어 센터 – 배경화면 |
|---|---|
| ![제어 센터: 애니메이션](screenshots/control-anime.png) | ![제어 센터: 배경화면](screenshots/control-wallpaper.png) |

## 요구 사항

- **KDE Plasma 6** (Bazzite / Fedora Atomic + Plasma 6.8에서 개발하고 테스트했습니다. Plasma 6을 쓰는 다른 배포판에서도 동작할 것입니다)
- **Pillow**가 있는 Python 3 (`python3-pillow`)
- 인터넷 연결 (AniList, Konachan, Danbooru)
- 선택: kitty(원하면 자동 설치), Starship/eza/bat/zoxide용 Homebrew, Kvantum

모든 것이 사용자 프로필에 설치되므로 **root 권한이 필요 없습니다**. 로그인 화면 배경화면을 설정할 때만 비밀번호를 한 번 묻습니다.

## 설치

**쉬운 방법 (추천):**

1. [최신 릴리스](https://github.com/propanisen/AnimeStage/releases/latest)에서 **AnimeStage.zip**을 내려받습니다.
2. 압축을 풉니다(오른쪽 클릭 → *여기에 압축 풀기*).
3. 폴더에서 **AnimeStage 설치**를 두 번 클릭하고 창의 안내를 따르세요. 언어, 패널, 애니메이션을 고르면 끝입니다.

**터미널에서 한 줄로:**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**git으로 (개발자용):**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # 무엇을 할지 보여 줌 (아무것도 바꾸지 않음)
./install.sh                 # 설치 (먼저 KDE 설정을 백업합니다)
```

옵션:

```bash
./install.sh --anime "Frieren"   # 처음부터 이 애니메이션으로 시작
./install.sh --lang ko           # 설치 프로그램과 테마의 언어
./install.sh --profile core      # 지금 패널 유지
```

설치가 끝나면 **시작 메뉴 → AnimeStage 제어 센터 → 애니메이션**을 열고 좋아하는 애니메이션을 검색하세요.

### 업데이트

AnimeStage는 하루에 한 번 GitHub에서 새 버전이 있는지 확인하고 알림으로 알려 줍니다. **지금 설치**만 누르면 됩니다 – **제어 센터 → 시스템 → Updates**에서 설치하거나 `animestage update install`을 실행해도 됩니다. 같은 곳에서 업데이트를 자동으로 설치하도록 할 수도 있습니다. 업데이트 전에는 매번 백업을 만듭니다. 확인이 필요 없다면 그곳에서 "끄기"를 고르거나 `animestage update off`를 실행하세요.

git 클론에서 직접 업데이트하기:

```bash
git pull
./update.sh          # 설정, 즐겨찾기, 패널은 그대로 유지됩니다
```

### 제거

**쉬운 방법:** 제어 센터 → 시스템 → **AnimeStage 제거…** – 창에서 먼저 확인한 뒤 모두 되돌립니다.

**터미널에서:**

```bash
./uninstall.sh            # 모두 제거하고 원래 KDE 설정을 복원
./uninstall.sh --purge    # 내려받은 이미지와 설정도 삭제
```

**설치와 제거 때 일어나는 일:** 설치 프로그램은 무엇이든 바꾸기 전에 KDE 설정(패널, 색상, 창 장식, 글꼴, 잠금 화면, 시작 화면 …)을 `~/.local/state/animestage/backups/original`에 저장합니다. 제거하면 AnimeStage의 모든 파일과 타이머를 지우고, 터미널·Firefox·VS Code·로그인 화면의 변경을 되돌린 다음 이 백업을 복원합니다 – 데스크톱이 설치 전과 똑같아집니다. 설치 후 패널을 바꿨다면 그 변경도 함께 되돌아갑니다. 백업 자체는 남아 있습니다.

## 콘텐츠 필터

AnimeStage는 **기본적으로 전체 이용가**입니다(필터 "엄격").

- **SFW**는 애니메이션의 모든 캐릭터를 보여 줍니다.
- **Ecchi / NSFW**를 켤 수 있지만 **성인 캐릭터만** 보여 줍니다. 나이는 AniList 정보(18세 이상)이거나 직접 표시한 것이어야 하며, 직접 표시는 AniList에 나이가 없거나 "1000+" 같은 판타지 나이만 있을 때만 가능합니다. AniList 기준 미성년자인 캐릭터는 어떤 방법으로도 잠금을 풀 수 없습니다.
- 노출이 있는 이미지는 다른 캐릭터가 없고, 더 어려 보이는 태그도 없을 때만 씁니다.
- **잠금 화면, 로그인 화면, 터미널, Firefox에는 항상 "safe" 이미지만 표시합니다.**
- 자체 테스트가 이 규칙을 확인하며, 규칙이 지워지거나 약해지면 설치 프로그램이 설치를 거부합니다.

**여성 캐릭터만** 표시하도록 할 수도 있습니다(제어 센터 → 애니메이션).

## 명령줄

```bash
animestage search frieren            # AniList 검색
animestage anime 154587 --apply      # 애니메이션 사용
animestage wall next | fav | ban     # 다음 배경화면 / 즐겨찾기에 저장 / 다시 보지 않기
animestage set wallswitch.minutes 60 # 바꾸는 간격
animestage themed new terminal --tags "night, city"   # 터미널 배경 직접 검색
animestage source check              # 이미지 사이트에 연결되는지 확인
animestage status
animestage --help
```

## 이미지 출처와 직접 추가하기

이미지 검색과 다운로드는 모두 한 파일에 있습니다: [`lib/animestage_sources.py`](../lib/animestage_sources.py).
사이트가 접속되지 않거나 다른 사이트를 쓰고 싶다면 그곳에 추가(`SOURCES`와 `PURPOSES`)하고 `./update.sh`를 실행하세요. 제어 센터의 **시스템 → 이미지 출처**에서 고를 수 있게 됩니다. Moebooru(Konachan, yande.re), Danbooru, Gelbooru 계열 사이트용 어댑터가 준비되어 있습니다.

## 번역

번역 파일은 [`i18n/`](../i18n/)에 있습니다. 언어마다 JSON 파일 하나입니다(독일어 원문 → 번역).
`tools/i18n-extract.py`로 번역이 빠진 문장을 확인할 수 있습니다. 수정이나 새 언어 추가를 환영합니다!

## 크레딧

- 애니메이션 정보: [AniList](https://anilist.co) · 배경화면: [Konachan](https://konachan.net) · 누끼 이미지: [Danbooru](https://danbooru.donmai.us) (AI 생성 이미지 금지)
- 글꼴: [M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c) (SIL OFL) · 아이콘: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (GPL-3.0)
- AnimeStage 자체에는 애니메이션 이미지가 들어 있지 않습니다 – 이미지는 애니메이션을 고를 때 내려받습니다. 작가 정보는 제어 센터에서 볼 수 있습니다(이미지에 마우스를 올려 보세요). 모든 캐릭터의 권리는 각 권리자에게 있습니다. 비상업적 팬 프로젝트이며 위 서비스와는 관련이 없습니다.

**propanisen**이 **Claude Opus 5.5**(Anthropic)와 함께 만들었습니다 – 디자인, 코드, 번역은 AI와의 대화 속에서 만들어졌습니다.

## 라이선스

[GPL-3.0](../LICENSE)
