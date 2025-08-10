#!/bin/bash

echo "GitHub Push Helper für claudecodeagents"
echo "========================================"
echo ""
echo "Dieses Script hilft dir beim Push zu GitHub."
echo ""
echo "Du brauchst ein GitHub Personal Access Token:"
echo "1. Gehe zu: https://github.com/settings/tokens/new"
echo "2. Wähle 'repo' scope"
echo "3. Generiere den Token"
echo ""
read -p "Gib deinen GitHub Username ein: " username
read -s -p "Gib deinen GitHub Personal Access Token ein: " token
echo ""

# Push mit Authentifizierung
git push https://${username}:${token}@github.com/SilvioTormen/claudecodeagents.git main

echo ""
echo "✅ Fertig! Dein Repository ist jetzt online:"
echo "https://github.com/SilvioTormen/claudecodeagents"
echo ""
echo "Andere können jetzt installieren mit:"
echo "curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install"