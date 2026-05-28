#!/usr/bin/bash
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
SCRIPTS_DIR="${CLAUDE_DIR}/scripts"
COMMANDS_DIR="${CLAUDE_DIR}/commands/project"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing project-workbench..."

mkdir -p "${SCRIPTS_DIR}" "${COMMANDS_DIR}"

cp "${REPO_DIR}/scripts/recent-projects.py" "${SCRIPTS_DIR}/"
cp "${REPO_DIR}/scripts/resume-project.py" "${SCRIPTS_DIR}/"
chmod +x "${SCRIPTS_DIR}/recent-projects.py" "${SCRIPTS_DIR}/resume-project.py"

cp "${REPO_DIR}/.claude/commands/project/new.md" "${COMMANDS_DIR}/"
cp "${REPO_DIR}/.claude/commands/project/resume.md" "${COMMANDS_DIR}/"
cp "${REPO_DIR}/.claude/commands/project/close.md" "${COMMANDS_DIR}/"

echo "  Scripts  -> ${SCRIPTS_DIR}/"
echo "  Commands -> ${COMMANDS_DIR}/"

if [[ ! -f "${SETTINGS_FILE}" ]]; then
    cat > "${SETTINGS_FILE}" <<'SETTINGS'
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python3 ~/.claude/scripts/recent-projects.py"
          }
        ]
      }
    ]
  }
}
SETTINGS
    echo "  Created  -> ${SETTINGS_FILE}"
elif ! python3 -c "
import json, sys
with open('${SETTINGS_FILE}') as f:
    d = json.load(f)
hooks = d.get('hooks', {}).get('SessionStart', [])
for h in hooks:
    for inner in h.get('hooks', []):
        if 'recent-projects.py' in inner.get('command', ''):
            sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
    python3 -c "
import json
with open('${SETTINGS_FILE}') as f:
    d = json.load(f)
hook_entry = {
    'hooks': [{
        'type': 'command',
        'command': 'python3 ~/.claude/scripts/recent-projects.py'
    }]
}
d.setdefault('hooks', {}).setdefault('SessionStart', []).append(hook_entry)
with open('${SETTINGS_FILE}', 'w') as f:
    json.dump(d, f, indent=2)
    f.write('\n')
"
    echo "  Hook     -> added SessionStart to ${SETTINGS_FILE}"
else
    echo "  Hook     -> already configured"
fi

echo ""
echo "Done. Commands available in any Claude Code session:"
echo "  /project:new      Create a new project workspace"
echo "  /project:resume   Resume an existing project"
echo "  /project:close    Close a completed project"
echo ""
echo "Projects will be stored at ~/workspace/projects/"
