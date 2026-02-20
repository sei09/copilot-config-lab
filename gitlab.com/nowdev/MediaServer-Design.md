# 📄 **MediaServer-Design.md（最新版・追記済み）**

```md
# メディアサーバ構築対話履歴（設計まとめ）

Author: ozaki × Copilot  
Date: 2026-02-19

---

# 1. 目的

- PC と VR デバイス（Skybox / 4K VR Player）での閲覧性を最大化する
- Jellyfin を中心にしたメタデータ管理
- メディアサーバが壊れても復元可能な構造
- 削除フラグ（お気に入り）を VR から付けて PC で削除
- 日付フォルダに複数 mp4 を置く運用を維持
- メーカー名（SSIS / IPX / MGS / FC2 / VRKM）でメタデータを整理
- **作品情報（スクレイピング）＋動画技術情報（ffprobe）を統合して CSV に蓄積する**

---

# 2. トップ階層の分類（ソース別）

Media/
├── FANZA/
├── JAV/ ← MGSなど
├── FC2/
└── VRJAV/
```

理由：

- Jellyfin のライブラリ単位で管理しやすい
- VRデバイスでもカテゴリとして表示される
- API / スクレイピングの処理をソース別に分けられる

---

# 3. メディア本体の構造（Jellyfin が監視）

```
Media/FANZA/
 └── 2026-02-18/
       ├── SSIS-123.mp4
       ├── SSIS-124.mp4
       ├── IPX-999.mp4
       └── ...
```

特徴：

- 「掘りたくない」運用を維持
- Jellyfin の「最近追加した作品」が正確
- VRデバイスでの閲覧性が高い
- 削除フラグ（お気に入り）→ PC で mp4 削除 → Jellyfin 自動反映

---

# 4. メタデータ倉庫（Jellyfin に登録しない）

```
Metadata/
 ├── FANZA/
 │     ├── SSIS/
 │     │     ├── SSIS-123/
 │     │     │     ├── poster.jpg
 │     │     │     ├── cover.jpg
 │     │     │     ├── folder.jpg
 │     │     │     ├── movie.nfo
 │     │     │     └── metadata.json
 │     │     └── SSIS-124/
 │     ├── IPX/
 │     │     └── IPX-999/
 │     └── ...
 ├── JAV/
 ├── FC2/
 └── VRJAV/
```

特徴：

- Jellyfin に登録しないのでライブラリが汚れない
- メディアサーバが壊れても復元が簡単
- API 再取得不要
- 品番検索がしやすい
- あなたの「ログ美学」に完全一致

---

# 5. Jellyfin の削除動作

## ✔ mp4 を削除した場合

- mp4 のみ削除される
- poster.jpg / cover.jpg / nfo / json は残る
- Jellyfin は作品をライブラリから除外する
- 付随ファイルは無害で問題なし

## ✔ フォルダ削除した場合

- フォルダ内のすべてが削除される

---

# 6. 削除フラグ運用（VR → Jellyfin → PC）

1. VRデバイスで「お気に入り」を付ける
2. Jellyfin に同期される
3. PC で「お気に入り一覧」を開く
4. mp4 を削除（付随ファイルは残す）
5. Jellyfin が自動でライブラリ更新

---

# 7. 付随ファイルの削除タイミング（推奨）

```
【即時】mp4のみ削除（VR→Jellyfin→PC）
【週1】孤立メタデータをスキャンしてCSV化
【3ヶ月】孤立メタデータをバッチ削除
```

---

# 8. スクレイピング対象サイトの選定（4ディレクトリ別）

```
FANZA/     → FANZA商品ページ（後々API）
JAV/       → MGS動画ページ
FC2/       → FC2公式コンテンツページ（JSON-LD）
VRJAV/     → FANZA VRカテゴリ（後々API）
```

---

# 9. FANZA画像仕様（pl / ps）

FANZAには2種類の画像が存在する：

| 種類   | 意味                    | 用途                                   |
| ------ | ----------------------- | -------------------------------------- |
| **pl** | portrait large（縦長）  | poster.jpg（Jellyfin）                 |
| **ps** | portrait spread（横長） | cover.jpg / folder.jpg（VR・Jellyfin） |

例：

```
ssis00123pl.jpg  ← 縦長
ssis00123ps.jpg  ← 横長（見開き）
```

---

# 10. CSV カラム構成（作品情報＋画像＋技術情報）

```
Source
ID
Title
Studio
Series
Actors
Genres
ReleaseDate
CoverPL
CoverPS
ScrapeDate
FilePath
MetadataPath

# ここから動画技術情報
Width
Height
Duration
DurationText
FileSize
FileSizeMB
VideoCodec
AudioCodec
FPS
Bitrate
```

---

# 11. 動画技術情報の取得（ffprobe）

Jellyfin ライブラリ更新時（＝mp4追加時）に ffprobe を実行し、以下を取得：

- 解像度（Width / Height）
- 再生時間（Duration / DurationText）
- ファイルサイズ（FileSize / FileSizeMB）
- コーデック（VideoCodec / AudioCodec）
- フレームレート（FPS）
- ビットレート（Bitrate）

理由：

- VRでの画質判断に直結
- 削除候補の判断が即できる
- OneCommanderで見ている情報を CSV に残せる
- AV1変換の効果測定ができる
- メタデータ倉庫の価値が上がる

---

# 12. metadata.json の構造（作品情報＋技術情報）

```
{
  "ID": "SSIS-123",
  "Source": "FANZA",
  "Title": "作品タイトル",
  "Studio": "S1",
  "Series": "SSIS",
  "Actors": ["三上悠亜"],
  "Genres": ["巨乳", "VR"],
  "ReleaseDate": "2024-01-01",
  "CoverPL": "https://...pl.jpg",
  "CoverPS": "https://...ps.jpg",

  "FileInfo": {
    "Width": 1920,
    "Height": 1080,
    "Duration": 7200,
    "DurationText": "02:00:00",
    "FileSizeMB": 4500,
    "VideoCodec": "h264",
    "AudioCodec": "aac",
    "FPS": 29.97,
    "Bitrate": 5000000
  },

  "ScrapeDate": "2026-02-19"
}
```

---

# 13. 今後の自動化候補

- スクレイピング → NFO → poster.jpg / cover.jpg 自動生成
- ffprobe → 技術情報取得 → CSV蓄積
- 孤立メタデータ検出スクリプト
- バッチ削除スクリプト
- metadata.json 標準フォーマットの拡張
- Jellyfin の Direct Play 成否分析

---

# End of Document

```

---

必要なら、この md を **GitHub リポジトリ用の README.md 形式**に整形したり、
章ごとに分割したり、
PowerShell スクリプトのテンプレートを追加することもできる。

次はどこを深掘りする？
- ffprobe のコード？
- スクレイピングの最小実装？
- CSV の自動追記？
- metadata.json の生成？
```
