# CopilotSessionhttps://github.com/sei09/CopilotSession/blob/main/README.md
ThisRepository 
windows re install memo
2026/04/07 0:20 sei09 Wite.

powershell 7.6.0 win-get command.
VSCode - msstore
Powertoys - msstore
phython - msstore PythonInstallManager 

check summary

1.first. copy powershell userprofile. and windows file path check 
2.VSCode file path and jsonsetting check.
(前回狙ったファイルと違うものをコピーしていた。再度初期設定として再構築。フォント、サイズあたり。Copilotへの承認はそのまま）
3.code extenthion 差分チェック
4.python 3.14 check
5.node install and rpm command check
6.windows terminall Powerline Prompt setting #今回初依頼
6.Git-Desktop インストーラー設定項目が分からないのでインストールしていない。
aiに任せる もしくはインストーラー項目を教えてもらう #覚えておいたほうがいいだろう。
7.GitHub repository main branch をD:\GitRepo 以下適切なフォルダへ同期。
8.上記リポジトリで powershell (&terminal) profile. vscode setting.json chck and make backupfile. を狙ったものがバックアップされているか人間がチェック。



---

コピー/検証用の正確なパスは以下です。

1. ユーザープロファイル基点  
- UserProfile: C:\Users\sei09  
- Roaming AppData: C:\Users\sei09\AppData\Roaming  
- Local AppData: C:\Users\sei09\AppData\Local  
- Documents: C:\Users\sei09\Documents  

2. PowerShell 7 のプロファイル  
- CurrentUserCurrentHost: C:\Users\sei09\Documents\PowerShell\Microsoft.PowerShell_profile.ps1（存在あり） 

このプロファイルでpowershellコマンドPATHが実行されるかチェックしてほしい。



- CurrentUserAllHosts: C:\Users\sei09\Documents\PowerShell\profile.ps1（未作成）  
- AllUsersCurrentHost: C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1（未作成）  
- AllUsersAllHosts: C:\Program Files\PowerShell\7\profile.ps1（未作成）  

3. 関連設定ファイル（今回の再構築で重要）  
- VS Code settings: C:\Users\sei09\AppData\Roaming\Code\User\settings.json（存在あり）  

この
                                

- VS Code keybindings: C:\Users\sei09\AppData\Roaming\Code\User\keybindings.json（未作成）  
- VS Code snippets: C:\Users\sei09\AppData\Roaming\Code\User\snippets（存在あり）  
- Windows Terminal settings: C:\Users\sei09\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json（存在あり）  

補足です。  
PowerShell プロファイルは「未作成」が正常なことも多いです。未作成のものは、必要になった時点で新規作成して問題ありません。  
また、今回は PowerShell 5.1 の代表パスも確認し、未作成でした。PowerShell 7 中心で運用するなら優先度は低めです。

すぐ使える検証コマンド（PowerShell）  
    $PROFILE | Format-List *  
    Test-Path $PROFILE.CurrentUserCurrentHost  
    Test-Path (Join-Path $env:APPDATA 'Code\User\settings.json')  
    Test-Path (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json')


---

# 作業再開テンプレ（コピペ用）

以下を新しいチャットの最初に貼る。

```text
【再開依頼】
目的:
- 

完了:
- 
- 

未完了:
- 
- 

対象リポジトリ:
- 

主な変更ファイル:
- 
- 

現在のブランチ:
- 

直近コミット:
- 

次にやってほしいこと（1タスク）:
- 

制約/希望:
- 小さくコミット
- 既存差分は勝手に戻さない
```


# 作業再開テンプレ（今回の記入済み）

以下を次回そのまま貼れば再開できる。

```text
【再開依頼】
目的:
- Windows再インストール後の復旧フローを、PowerShellスクリプトとGit運用で再現可能にする。

完了:
- Python 3.14 / Node 系チェックを実施。
- Check-PathHealth.ps1 を作成して実行済み。
- TerminalFullPack の bootstrap 系（Install/Apply/HealthCheck）を整備。
- Apps-Core 調整をコミット済み。
- repo-sync / backup-verify フロー追加をコミット済み。

未完了:
- TerminalFullPack/README.md のコメント・説明の日本語化を仕上げる。
- GitHub remote/upstream の最終確認と push。

対象リポジトリ:
- d:\DevSpace\my-project\SysRestoreScripts

主な変更ファイル:
- TerminalFullPack/Invoke-RepoSync.ps1
- TerminalFullPack/Verify-BackupTargets.ps1
- TerminalFullPack/Backup-Targets.json
- TerminalFullPack/RepoSync-Targets.txt
- TerminalFullPack/README.md

現在のブランチ:
- chore/bootstrap-baseline（想定。再開時に確認してから作業）

直近コミット:
- feat: add repo-sync and backup-verify flows

次にやってほしいこと（1タスク）:
- まず TerminalFullPack/README.md を日本語化し、必要なら小さく1コミットにまとめる。

制約/希望:
- 小さくコミット
- 既存差分は勝手に戻さない
```
