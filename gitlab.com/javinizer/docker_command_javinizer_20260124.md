# 📄 **docker_command_javinizer_20260124.md**

````markdown
# Javinizer Docker Commands (2026-01-24)

## 📦 Create Docker Volume

Javinizer の設定を Docker 内で永続化するための Volume を作成します。

```powershell
docker volume create javinizer-config
```
````

---

## 🚀 Run Javinizer Container Using Volume

Volume を `/config` にマウントしてコンテナを起動します。

```powershell
docker run -d `
  --name javinizer `
  --restart unless-stopped `
  -p 8600:8600 `
  -v javinizer-config:/config `
  javinizer/javinizer:latest
```

---

## 🛠️ Enter Container to Edit Settings

コンテナ内で設定ファイルを直接編集します。

```powershell
docker exec -it javinizer bash
# Inside container:
nano /config/jvSettings.json
```

---

## 📤 Copy Settings File Out to Windows

必要に応じて設定ファイルを Windows 側へバックアップします。

```powershell
docker cp javinizer:/config/jvSettings.json .
```

---

## 📥 Copy Settings File Back Into Container

Windows 側で編集した設定ファイルをコンテナへ戻します。

```powershell
docker cp jvSettings.json javinizer:/config/jvSettings.json
```

---

## 📝 Notes

- Volume を使うことで Windows のドライブ共有に依存せず、Docker 内で完結した運用が可能。
- 設定ファイルは `/config/jvSettings.json` に保存される。
- コンテナを削除しても Volume は残るため、設定は保持される。

```

---

必要なら、この md を **GitHub の lab リポジトリにそのまま置けるように整形**したり、
**Javinizer の運用メモ**として拡張したバージョンも作れるよ。

次はどうする？
```
