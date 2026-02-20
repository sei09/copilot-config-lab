# renamecsv_ver2.ps1
# ------------------------------------------------------------
# ScrapeToCsv_ver2.ps1 で生成した CSV を元に、
# oldname + Keyword を結合して newname を作成し、
# 実ファイルをリネームするスクリプト。
#
# ・oldname の拡張子をそのまま利用
# ・Keyword と結合して newname を生成
# ・禁止文字を除去
# ・FilePath / newFilePath / oldname / newname をログに残す
# ------------------------------------------------------------

$folder     = "B:\DownlordsWork\FC2-2026-02Part4\"
$csvPath    = Join-Path $folder "FC2_titles_result_2026-02-18_17-00-53.csv"

# タイムスタンプ付き rename_complete.csv
$timestamp  = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
$outputPath = Join-Path $folder "rename_complete_$timestamp.csv"

# CSV 読み込み
$data = Import-Csv -Path $csvPath

# 禁止文字一覧
$invalidChars = [IO.Path]::GetInvalidFileNameChars()

foreach ($row in $data) {

    # ScrapeToCsv_ver2.ps1 の列構造に合わせる
    $fullPath = $row.FilePath
    $oldname  = $row.oldname
    $keyword  = $row.Keyword

    # oldname の拡張子を取得
    $ext      = [System.IO.Path]::GetExtension($oldname)

    # oldname の拡張子を除いた部分
    $oldBase  = [System.IO.Path]::GetFileNameWithoutExtension($oldname)

    # newname = oldname_without_ext + " " + keyword + ext
    $newname  = "$oldBase $keyword$ext"

    # 禁止文字除去
    foreach ($c in $invalidChars) {
        $newname = $newname -replace [Regex]::Escape($c), ' '
    }
    $newname = $newname.Trim()

    # 新しいフルパス
    $newFullPath = Join-Path $folder $newname

    # リネーム実行
    if (Test-Path $fullPath) {
        Rename-Item -Path $fullPath -NewName $newname
    } else {
        # ファイルが見つからない場合は newFullPath を空欄に
        $newFullPath = ""
    }

    # ログ列を追加
    $row | Add-Member -NotePropertyName "newFilePath" -NotePropertyValue $newFullPath
    $row | Add-Member -NotePropertyName "newname"     -NotePropertyValue $newname
}

# ログ出力
$data | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

Write-Host "リネーム処理が完了しました → $outputPath"