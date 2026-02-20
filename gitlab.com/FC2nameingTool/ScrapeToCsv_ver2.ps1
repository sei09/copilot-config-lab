# ScrapeToCsv_ver2.ps1
# ------------------------------------------------------------
# FC2_titles.txt に記載されたファイル名を元に、
# Nyaa（sukebei）からタイトルをスクレイピングして
# CSV にまとめるスクリプト。
#
# ・全件数を表示
# ・20件ごとに進捗を表示
# ・フルパス / oldname / BaseID / URL / Keyword を記録
# ------------------------------------------------------------

# 作業ディレクトリ
$folder    = "B:\DownlordsWork\FC2-2026-02Part4\"

# 入力テキスト（1行1ファイル名）
$inputTxt  = Join-Path $folder "FC2_titles.txt"

# タイムスタンプ付きの出力CSV
$timestamp = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
$outputCsv = Join-Path $folder "FC2_titles_result_$timestamp.csv"

# テキストファイルを読み込み（1行＝1ファイル名）
$files     = Get-Content -Path $inputTxt
$results   = @()

# 総件数とカウンタ
$total     = $files.Count
$counter   = 0

Write-Host "スクレイピング開始：全 $total 件"

foreach ($file in $files) {

    $counter++

    # ------------------------------------------------------------
    # 1. フルパスを決定（相対名なら $folder と結合）
    # ------------------------------------------------------------
    if ([System.IO.Path]::IsPathRooted($file)) {
        $fullPath = $file
    } else {
        $fullPath = Join-Path $folder $file
    }

    # oldname（拡張子あり）
    $oldname  = [System.IO.Path]::GetFileName($fullPath)

    # 拡張子なし
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fullPath)

    # ------------------------------------------------------------
    # 2. 先頭6〜7桁の数字を BaseID として抽出
    # ------------------------------------------------------------
    if ($baseName -match '^(\d{6,7})') {
        $baseID = $matches[1]
    } else {
        $baseID = $baseName
    }

    # Nyaa 検索URL
    $url = "https://sukebei.nyaa.si/?f=2&c=2_2&q=$baseID"

    try {
        # ------------------------------------------------------------
        # 3. Web 取得（HTML）
        # ------------------------------------------------------------
        $html = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop

        # ------------------------------------------------------------
        # 4. HTML からタイトル抽出
        # ------------------------------------------------------------
        if ($html.Content -match '<td colspan="2">\s*<a href="[^"]+" title="([^"]+)"') {
            $title = $matches[1]
        } else {
            $title = "取得失敗"
        }

        # ------------------------------------------------------------
        # 5. 結果をオブジェクト化して配列に追加
        # ------------------------------------------------------------
        $results += [PSCustomObject]@{
            FilePath = $fullPath
            oldname  = $oldname
            BaseID   = $baseID
            URL      = $url
            Keyword  = $title
        }
    }
    catch {
        # ------------------------------------------------------------
        # 6. エラー時（ページ取得不可）
        # ------------------------------------------------------------
        $results += [PSCustomObject]@{
            FilePath = $fullPath
            oldname  = $oldname
            BaseID   = $baseID
            URL      = $url
            Keyword  = "ページ取得エラー"
        }
    }

    # ------------------------------------------------------------
    # 7. 20件ごとに進捗表示
    # ------------------------------------------------------------
    if ($counter % 20 -eq 0) {
        Write-Host "進行中… $counter / $total 件完了"
    }
}

Write-Host "スクレイピング完了：全 $total 件処理済み"

# ------------------------------------------------------------
# 8. CSV 出力
# ------------------------------------------------------------
$results | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8
Write-Host "CSV 出力完了 → $outputCsv"