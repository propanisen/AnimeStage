# AnimeStage

**把你的 KDE Plasma 6 桌面變成你最愛的動畫。**
輸入一部動畫，AnimeStage 就會圍繞它打造整個桌面：輪播的桌布、處處相配的色彩、開始選單裡的角色，以及主題化的終端機、Firefox 和 VS Code。

🌐 [English](../README.md) · [Deutsch](README.de.md) · [日本語](README.ja.md) · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · **繁體中文** · [한국어](README.ko.md)

![搭配《葬送的芙莉蓮》桌布與 AnimeStage 面板的桌面](screenshots/desktop.jpg)

## 功能

- **任何動畫都可以** – 透過 AniList 搜尋；標題、橫幅和角色（含年齡）會自動取得。
- **輪播桌布** – 每 2 小時（可調整）從 Konachan 取得新圖片，可依角色、篩選和氛圍挑選。可以加入我的最愛或排除圖片。
- **色彩跟著桌布走** – 從每張新圖片擷取強調色，套用到 Plasma、視窗裝飾、圖示（Papirus 資料夾）、終端機、Firefox 和 VS Code。
- **動畫風格面板** – 附角色去背圖的開始選單、顯示視窗標題的工作管理員、音樂膠囊、CPU/RAM/GPU 圓環和行事曆。
- **終端機** – 主題色的 kitty 或 Konsole，附新圖片與系統資訊的問候語，Starship 提示字元，也可以用圖片當終端機背景。
- **Firefox** – 分頁和網址列使用相配的色彩，新分頁的圖片每次啟動都會更換。
- **鎖定畫面和登入畫面**也會顯示你的桌布（登入：Plasma Login Manager）。
- **控制中心** – 一切都在同一個視窗完成，不需要編輯設定檔。
- **13 種語言** – 依照系統語言，可在控制中心切換。

### 像 Windows 一樣的工作列

![顯示視窗標題的工作列](screenshots/taskbar.png)

每個視窗都有自己的項目，圖示旁顯示標題——兩個 Firefox 視窗就是兩個項目。釘選的程式會留在你放的位置，它們的視窗也在那裡開啟。在 **控制中心 → 外觀 → 工作管理員** 中可以關閉標題、將視窗分組或選擇寬度（窄 / 中 / 寬）。

### 桌布與色彩

![三張桌布，以及 AnimeStage 從每張擷取的色彩](screenshots/wallpapers.jpg)

每張新桌布都帶來自己的色彩：AnimeStage 從圖片擷取強調色與背景色，重新為面板、視窗、圖示、終端機、Firefox 和 VS Code 上色——每 2 小時自動進行。每張圖片下方的面板顯示的就是該圖片的色彩。

### 開始選單、行事曆和系統負載

![AnimeStage：開始選單、行事曆和系統負載](screenshots/preview.png)

| 控制中心 – 動畫與角色 | 控制中心 – 桌布 |
|---|---|
| ![控制中心：動畫](screenshots/control-anime.png) | ![控制中心：桌布](screenshots/control-wallpaper.png) |

## 系統需求

- **KDE Plasma 6**（在 Bazzite / Fedora Atomic + Plasma 6.8 上開發與測試；其他搭載 Plasma 6 的發行版應該也能使用）
- Python 3 與 **Pillow**（`python3-pillow`）
- 網路連線（AniList、Konachan、Danbooru）
- 選用：kitty（可自動安裝）、用於 Starship/eza/bat/zoxide 的 Homebrew、Kvantum

所有內容都安裝在你的使用者設定檔中 – **不需要 root 權限**。只有登入畫面的桌布需要輸入一次密碼。

## 安裝

**簡單方式（推薦）：**

1. 從[最新版本](https://github.com/propanisen/AnimeStage/releases/latest)下載 **AnimeStage.zip**。
2. 解壓縮（右鍵 → *解壓縮到這裡*）。
3. 在資料夾中雙擊 **安裝 AnimeStage**，依照視窗操作：語言、面板、動畫——完成。

**終端機裡的一行指令：**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**使用 git（開發者）：**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # 顯示將會執行的動作（不做任何變更）
./install.sh                 # 安裝（會先備份你的 KDE 設定）
```

選項：

```bash
./install.sh --anime "Frieren"   # 直接以某部動畫開始
./install.sh --lang zh_TW        # 安裝程式和佈景主題的語言
./install.sh --profile core      # 保留目前的面板
```

接著開啟 **開始選單 → AnimeStage 控制中心 → 動畫**，搜尋你的動畫。

### 更新

AnimeStage 每天在 GitHub 上檢查一次是否有新版本，並顯示通知。在 **控制中心 → 系統 → Updates** 中一鍵安裝（或 `animestage update install`）。通知裡有 **立即安裝** 按鈕——也可以讓更新自動安裝（在同一處設定）。每次更新前都會先備份。不想檢查？在那裡取消勾選，或執行 `animestage update off`。

從 git 複製手動更新：

```bash
git pull
./update.sh          # 你的設定、我的最愛和面板都會保留
```

### 解除安裝

**簡單方式：** 控制中心 → 系統 → **解除安裝 AnimeStage …** ——會先跳出視窗確認，並還原一切。

**在終端機中：**

```bash
./uninstall.sh            # 移除全部內容並還原原本的 KDE 設定
./uninstall.sh --purge    # 也刪除下載的圖片和設定
```

**安裝與解除安裝時會發生什麼：** 在做任何變更之前，安裝程式會把你的 KDE 設定（面板、色彩、視窗裝飾、字型、鎖定畫面、啟動畫面 …）儲存到 `~/.local/state/animestage/backups/original`。解除安裝會刪除所有 AnimeStage 檔案與計時器，復原對終端機、Firefox、VS Code 和登入畫面的變更，然後還原這份備份——桌面會和以前完全一樣。安裝後對面板做的變更也會被重設。備份本身會保留。

## 內容篩選

AnimeStage **預設為普遍級**（篩選為「嚴格」）。

- **SFW** 顯示動畫的所有角色。
- **Ecchi / NSFW** 可以開啟，但**只會顯示成年角色**：年齡必須來自 AniList（18 歲以上），或由你自行標記——只有在 AniList 沒有年齡或只有「1000+」這類奇幻年齡時才能標記。AniList 中未成年的角色永遠無法解鎖。
- 只有在圖片中沒有其他角色、也沒有標籤暗示較年幼者時，才會使用暴露的圖片。
- **鎖定畫面、登入畫面、終端機和 Firefox 一律只顯示「safe」圖片。**
- 這些規則由自我檢測確認；若規則被移除或削弱，安裝程式會拒絕安裝。

你也可以**只顯示女性角色**（控制中心 → 動畫）。

## 命令列

```bash
animestage search frieren            # 在 AniList 搜尋
animestage anime 154587 --apply      # 使用某部動畫
animestage wall next | fav | ban     # 下一張桌布、加入我的最愛、不再顯示
animestage set wallswitch.minutes 60 # 輪播間隔
animestage themed new terminal --tags "night, city"   # 自訂搜尋終端機背景
animestage source check              # 圖片網站能否連線？
animestage status
animestage --help
```

## 圖片來源與新增自己的來源

所有圖片的搜尋與下載都集中在一個檔案：[`lib/animestage_sources.py`](../lib/animestage_sources.py)。
若某個網站無法連線或你想換一個，就在那裡新增（`SOURCES` 和 `PURPOSES`），然後執行 `./update.sh` – 它就會出現在控制中心的 **系統 → 圖片來源**。已為 Moebooru（Konachan、yande.re）、Danbooru 和 Gelbooru 類網站準備好轉接器。

## 翻譯

翻譯檔位於 [`i18n/`](../i18n/) – 每種語言一個 JSON 檔（德文原文 → 譯文）。
`tools/i18n-extract.py` 會列出缺少的文字。歡迎修正翻譯或新增語言！

## 致謝

- 動畫資料：[AniList](https://anilist.co) · 桌布：[Konachan](https://konachan.net) · 去背圖：[Danbooru](https://danbooru.donmai.us)（那裡禁止 AI 圖片）
- 字型：[M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c)（SIL OFL） · 圖示：[Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)（GPL-3.0）
- AnimeStage 不包含任何動畫圖片 – 所有圖片都在你選擇動畫時才下載。繪師資訊顯示在控制中心（將滑鼠移到圖片上）。所有角色 © 屬於各自的權利人。這是非商業的粉絲專案，與上述服務無關。

由 **propanisen** 與 **Claude Opus 5.5**（Anthropic）共同製作 – 設計、程式碼和翻譯都是在與 AI 的對話中完成的。

## 授權

[GPL-3.0](../LICENSE)
