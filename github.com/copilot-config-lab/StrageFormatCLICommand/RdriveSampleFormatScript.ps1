# ================================
#  Full Format R: (Virtual Disk 11)
#  NTFS / Logging
# ================================

$log = "C:\format_Rdrive_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

"=== Format Start $(Get-Date) ===" | Out-File $log -Append
"Target Drive: R (Virtual Disk 11)" | Out-File $log -Append

# 非クイック（完全）フォーマット
Format-Volume -DriveLetter R -FileSystem NTFS -Full -Confirm:$false 2>&1 |
    Out-File $log -Append

"=== Format End $(Get-Date) ===" | Out-File $log -Append