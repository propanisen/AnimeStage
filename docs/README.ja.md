# AnimeStage

**KDE Plasma 6 のデスクトップを、好きなアニメ一色に。**
アニメ名を入力するだけで、AnimeStage がデスクトップ全体を作り上げます：切り替わる壁紙、どこでも統一されたカラー、スタートメニューのキャラクター、テーマに合わせたターミナル、Firefox、VS Code。

🌐 [English](../README.md) · [Deutsch](README.de.md) · **日本語** · [Français](README.fr.md) · [Español](README.es.md) · [Português (BR)](README.pt_BR.md) · [Italiano](README.it.md) · [Polski](README.pl.md) · [Nederlands](README.nl.md) · [Русский](README.ru.md) · [简体中文](README.zh_CN.md) · [繁體中文](README.zh_TW.md) · [한국어](README.ko.md)

![フリーレンの壁紙と AnimeStage パネルのデスクトップ](screenshots/desktop.jpg)

## 機能

- **好きなアニメを選ぶ** – AniList で検索。タイトル、バナー、キャラクター（年齢付き）を自動で取得します。
- **切り替わる壁紙** – Konachan から 2 時間ごと（変更可）に新しい画像。キャラクター、フィルター、ムードで選べます。お気に入り保存や除外も可能。
- **壁紙に合わせたカラー** – 新しい画像ごとにアクセントカラーを抽出し、Plasma、ウィンドウ装飾、アイコン（Papirus フォルダー）、ターミナル、Firefox、VS Code に適用します。
- **アニメ風パネル** – キャラクター切り抜き付きのスタートメニュー、ウィンドウ名付きタスクマネージャー、音楽ピル、CPU/RAM/GPU リング、カレンダー。
- **ターミナル** – テーマカラーの kitty または Konsole、新しい画像とシステム情報の挨拶、Starship プロンプト、ターミナル背景の画像（任意）。
- **Firefox** – タブとアドレスバーを合う色に、起動のたびに変わる新しいタブの画像。
- **ロック画面とログイン画面**にも壁紙を表示（ログイン：Plasma Login Manager）。
- **コントロールセンター** – すべてを 1 つのウィンドウで。設定ファイルの編集は不要です。
- **13 言語** – システムの言語に従い、コントロールセンターで切り替え可能。

### Windows のようなタスクバー

![ウィンドウ名が表示されるタスクバー](screenshots/taskbar.png)

ウィンドウごとにアイコンの横に名前付きの項目が表示されます。Firefox のウィンドウが 2 つなら項目も 2 つです。ピン留めしたアプリは置いた場所にとどまり、ウィンドウもそこに開きます。**コントロールセンター → 外観 → タスクマネージャー** で名前の非表示、ウィンドウのグループ化、幅（狭い / 中 / 広い）を設定できます。

### 壁紙と色

![3 枚の壁紙と、それぞれから AnimeStage が取り出した色](screenshots/wallpapers.jpg)

新しい壁紙ごとに色も変わります。AnimeStage が画像からアクセント色と背景色を取り出し、パネル、ウィンドウ、アイコン、ターミナル、Firefox、VS Code を塗り替えます – 2 時間ごとに自動で。各画像の下のパネルは、その画像の色を表しています。

### スタートメニュー、カレンダー、システム負荷

![AnimeStage：スタートメニュー、カレンダー、システム負荷](screenshots/preview.png)

| コントロールセンター – アニメとキャラクター | コントロールセンター – 壁紙 |
|---|---|
| ![コントロールセンター：アニメ](screenshots/control-anime.png) | ![コントロールセンター：壁紙](screenshots/control-wallpaper.png) |

## 必要なもの

- **KDE Plasma 6**（Bazzite / Fedora Atomic + Plasma 6.8 で開発・テスト。Plasma 6 のほかのディストリビューションでも動くはずです）
- Python 3 と **Pillow**（`python3-pillow`）
- インターネット接続（AniList、Konachan、Danbooru）
- 任意：kitty（必要なら自動インストール）、Starship/eza/bat/zoxide 用の Homebrew、Kvantum

すべてユーザープロファイルにインストールされます – **root 権限は不要**です。ログイン画面の壁紙だけ、最初に一度パスワードを聞かれます。

## インストール

**かんたんな方法（おすすめ）：**

1. [最新リリース](https://github.com/propanisen/AnimeStage/releases/latest) から **AnimeStage.zip** をダウンロード。
2. 展開します（右クリック → *ここに展開*）。
3. フォルダー内の **AnimeStage をインストール** をダブルクリックし、ウィンドウに従うだけ：言語、パネル、アニメ – 完了。

**ターミナルで 1 行：**

```bash
curl -fsSL https://github.com/propanisen/AnimeStage/releases/latest/download/get.sh | bash
```

**git で（開発者向け）：**

```bash
git clone https://github.com/propanisen/AnimeStage.git
cd AnimeStage
./install.sh --plan          # 何が行われるかを表示（何も変更しません）
./install.sh                 # インストール（先に KDE 設定をバックアップします）
```

オプション：

```bash
./install.sh --anime "Frieren"   # すぐにアニメを設定して開始
./install.sh --lang ja           # インストーラーとテーマの言語
./install.sh --profile core      # 今のパネルをそのまま使う
```

その後 **スタートメニュー → AnimeStage コントロールセンター → アニメ** を開いて、アニメを検索してください。

### アップデート

AnimeStage は 1 日 1 回 GitHub で新しいリリースを確認し、通知を表示します。**コントロールセンター → システム → Updates** でワンクリックでインストールできます（または `animestage update install`）。通知には **今すぐインストール** ボタンがあります – 自動インストールにすることもできます（同じ場所で設定）。アップデートの前には毎回バックアップを作成します。確認が不要なら、そこでチェックを外すか `animestage update off` を実行してください。

git クローンから手動で更新する場合：

```bash
git pull
./update.sh          # 設定、お気に入り、パネルはそのまま残ります
```

### アンインストール

**かんたんな方法：** コントロールセンター → システム → **AnimeStage をアンインストール …** – ウィンドウで確認してから、すべて元に戻します。

**ターミナルで：**

```bash
./uninstall.sh            # すべて削除し、元の KDE 設定を復元
./uninstall.sh --purge    # ダウンロードした画像と設定も削除
```

**インストールとアンインストールで何が起きるか：** 何かを変更する前に、インストーラーは KDE の設定（パネル、色、ウィンドウ装飾、フォント、ロック画面、スプラッシュ画面 …）を `~/.local/state/animestage/backups/original` に保存します。アンインストールすると AnimeStage のファイルとタイマーをすべて削除し、ターミナル・Firefox・VS Code・ログイン画面の変更を元に戻してから、このバックアップを復元します – デスクトップは以前とまったく同じになります。インストール後にパネルに加えた変更もリセットされます。バックアップ自体は残ります。

## コンテンツフィルター

AnimeStage は**初期状態で全年齢向け**です（フィルター「厳しめ」）。

- **SFW** はアニメのすべてのキャラクターを表示します。
- **Ecchi / NSFW** は有効にできますが、**成人キャラクターだけ**が対象です：年齢は AniList（18 歳以上）から取得するか、自分で印を付けます。印を付けられるのは、AniList に年齢がない場合か「1000+」のようなファンタジー年齢の場合だけです。AniList で未成年のキャラクターは決して解除できません。
- 露出のある画像は、ほかのキャラクターが写っておらず、年少を示すタグがない場合にだけ使われます。
- **ロック画面、ログイン画面、ターミナル、Firefox は常に「safe」の画像だけです。**
- これらのルールはセルフテストで確認され、削除・緩和されているとインストーラーは中止します。

**女性キャラクターだけ**を表示することもできます（コントロールセンター → アニメ）。

## コマンドライン

```bash
animestage search frieren            # AniList で検索
animestage anime 154587 --apply      # アニメを設定
animestage wall next | fav | ban     # 次の壁紙、お気に入りに保存、二度と表示しない
animestage set wallswitch.minutes 60 # 切り替え間隔
animestage themed new terminal --tags "night, city"   # ターミナル背景を自分で検索
animestage source check              # 画像サイトに接続できるか確認
animestage status
animestage --help
```

## 画像ソースと独自ソースの追加

画像の検索とダウンロードはすべて 1 つのファイルにまとまっています：[`lib/animestage_sources.py`](../lib/animestage_sources.py)。
サイトが停止したときや別のサイトを使いたいときは、そこ（`SOURCES` と `PURPOSES`）に追加して `./update.sh` を実行してください。コントロールセンターの **システム → 画像ソース** に表示されます。Moebooru（Konachan、yande.re）、Danbooru、Gelbooru 系サイト用のアダプターが用意されています。

## 翻訳

翻訳は [`i18n/`](../i18n/) にあります – 言語ごとに 1 つの JSON ファイル（ドイツ語の原文 → 翻訳）。
`tools/i18n-extract.py` で未翻訳のテキストを確認できます。修正や新しい言語の追加を歓迎します！

## クレジット

- アニメ情報：[AniList](https://anilist.co) · 壁紙：[Konachan](https://konachan.net) · 切り抜き：[Danbooru](https://danbooru.donmai.us)（AI 生成画像は禁止）
- フォント：[M PLUS Rounded 1c](https://fonts.google.com/specimen/M+PLUS+Rounded+1c)（SIL OFL） · アイコン：[Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)（GPL-3.0）
- AnimeStage にはアニメ画像は含まれていません – すべてアニメを選んだときにダウンロードされます。アーティスト名はコントロールセンターで表示されます（画像にカーソルを合わせる）。すべてのキャラクターの著作権は各権利者に帰属します。非営利のファンプロジェクトであり、上記サービスとは無関係です。

制作：**propanisen** と **Claude Opus 5.5**（Anthropic） – デザイン、コード、翻訳は AI との対話で作られました。

## ライセンス

[GPL-3.0](../LICENSE)
