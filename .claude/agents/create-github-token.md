# GitHub Token Creation & Push Instructions

## 🔑 Schnellste Methode zum Upload

### 1. Token erstellen (2 Minuten)

Öffne diesen Link in deinem Browser:
**https://github.com/settings/tokens/new?scopes=repo&description=claudecodeagents-upload**

Dieser Link:
- Öffnet direkt die Token-Erstellung
- Hat bereits "repo" Berechtigung vorausgewählt
- Hat bereits einen Namen vorgeschlagen

Klicke einfach auf **"Generate token"** ganz unten und kopiere den Token!

### 2. Repository hochladen (30 Sekunden)

Führe diesen Befehl aus (ersetze YOUR_TOKEN mit dem kopierten Token):

```bash
cd /agentsetup && git push https://SilvioTormen:YOUR_TOKEN@github.com/SilvioTormen/claudecodeagents.git main
```

### 3. Fertig! 🎉

Dein Repository ist dann live unter:
**https://github.com/SilvioTormen/claudecodeagents**

Andere können dann installieren mit:
```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install
```

## Alternative: Ohne Token mit Browser

1. Gehe zu: https://github.com/SilvioTormen/claudecodeagents
2. Klicke auf "uploading an existing file"
3. Ziehe alle Dateien aus `/agentsetup` in den Browser
4. Committe die Dateien

---

**Hinweis**: Der Token kann nach dem Upload gelöscht werden unter:
https://github.com/settings/tokens