# ストレージ初期化手順（HDD / SSD / NVMe）

最終更新：$(Get-Date -Format 'yyyy-MM-dd')

---

## 1. HDD（磁気ディスク）を完全フォーマット（非クイック）

### PowerShell（推奨）

```powershell
# ログ保存先（ユーザーフォルダ）
$log = "$env:USERPROFILE\format_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

"=== Format Start $(Get-Date) ===" | Out-File $log -Append
"Target Drive: R" | Out-File $log -Append

Format-Volume -DriveLetter R -FileSystem NTFS -Full -Confirm:$false 2>&1 |
    Out-File $log -Append

"=== Format End $(Get-Date) ===" | Out-File $log -Append
```

### 備考

- 完全フォーマットは **HDD のみ推奨**
- ログ保存先は `$env:USERPROFILE` が安全  
  ※ D: など他ドライブでも可
  ```powershell
  $log = "D:\Logs\format_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
  ```

---

## 2. SSD / NVMe のフォーマット（クイック推奨）

### PowerShell

```powershell
Format-Volume -DriveLetter X -FileSystem NTFS -Confirm:$false
```

### 備考

- SSD / NVMe に **完全フォーマット（Full）は不要・非推奨**
- 初期化したい場合はメーカーの Secure Erase を使用
  - Samsung → Magician
  - WD → Dashboard
  - Crucial → Storage Executive
  - Kingston → SSD Manager

---

## 3. ラベル付け（任意）

```powershell
Set-Volume -DriveLetter R -NewFileSystemLabel "任意のラベル"
```

---

## 4. 注意

- ドライブ文字の確認は必須
- 必要データは事前に退避
- HDD は Full、SSD/NVMe は Quick が基本方針
