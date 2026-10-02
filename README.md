# copilot-config-lab

Copilotとの対話を通じて設計・成長する構成ラボ。
PowerShell と VS Code の設定を Git で管理します。

## 構成
- powershell/: PowerShell プロファイル
- vscode/: VS Code 設定
- scripts/export-settings.ps1: 実環境からリポジトリへ取り込み
- scripts/import-settings.ps1: リポジトリから実環境へ反映

2026/10/03



## Windows再インストール後のVS Code設定

- `vscode/settings.json` にエディターのフォントと文字サイズを記録します。
- フォントファイル自体はこのリポジトリに含まれません。Windows再インストール後、先に使用するフォントをインストールしてください。
- VS CodeのSettings Syncを使うと、VS Codeの設定やプロファイルを同期できます。GitHubアカウントは同期へのサインインに使われますが、リポジトリへのコミットやpushとは別の仕組みです。
- このリポジトリは設定の記録と変更履歴用です。個人の通常更新は`main`にコミットし、試験的な変更やレビューが必要な場合はブランチを使います。

## スクリプトの状態

`scripts/export-settings.ps1`と`scripts/import-settings.ps1`は安全のため無効化されています。実行しないでください。
