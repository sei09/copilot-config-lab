# ベースディレクトリの定義 Cドライブ以下に作成する場合は D を C へリネームしてください。
$base = "D:\GitRepos"

# ベースディレクトリが存在しない場合は作成
if (-not (Test-Path $base)) {
    New-Item -ItemType Directory -Path $base -Force | Out-Null
    Write-Host "作成: $base" -ForegroundColor Yellow
} else {
    Write-Host "既存: $base" -ForegroundColor DarkGray
}

# フォルダ構成リスト
$folders = @(
    "$base\DevTools\ExtendedTools\oh-my-posh",
    "$base\DevTools\GlobalTools\tool_image",
    "$base\DevTools\WindowsFreeSoft\tool_image",
    "$base\SECONDARY_Account_Name",
    "$base\sei09\github.com",
    "$base\sei09\gitlab.com\Scripts_Dev\case1",
    "$base\sei09\gitlab.com\Scripts_Dev\case_AutoRename_ScrapingDataToFikename",
    "$base\sei09\gitlab.com\Scripts_Dev\case_Scraping_Nyaacom\DATA",
    "$base\sei09\gitlab.com\日記MdFiles"
)

# フォルダ作成処理（ログ付き）
foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "作成: $folder" -ForegroundColor Yellow
    } else {
        Write-Host "既存: $folder" -ForegroundColor DarkGray
    }
}

Write-Host "`n✅ repo_bootstrap.ps1 によるフォルダ構成の生成が完了しました。" -ForegroundColor Cyan
