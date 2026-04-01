# copilot-config-lab

Copilotとの対話を通じて設計・成長する構成ラボ。
PowerShell と VS Code の設定を Git で管理します。

## 構成
- powershell/: PowerShell プロファイル
- vscode/: VS Code 設定
- scripts/export-settings.ps1: 実環境からリポジトリへ取り込み
- scripts/import-settings.ps1: リポジトリから実環境へ反映

## 使い方
1. 取り込み
   pwsh -ExecutionPolicy Bypass -File .\scripts\export-settings.ps1 -UserName sei09
2. コミット
   git add .
   git commit -m "Update settings"
3. 反映
   pwsh -ExecutionPolicy Bypass -File .\scripts\import-settings.ps1 -UserName sei09
