---
mode: primary
description: Plan mode. Disallows all edit tools.
model: opencode/minimax-m2.5-free
permission:
  "*": allow
  doom_loop: ask
  external_directory:
    "*": ask
    /home/ubuntu/.local/share/opencode/tool-output/*: allow
    /tmp/opencode/*: allow
    /home/ubuntu/.agents/skills/skill-registry/*: allow
    /home/ubuntu/.agents/skills/skill-finder/*: allow
    /home/ubuntu/.agents/skills/skill-creator/*: allow
    /home/ubuntu/.agents/skills/command-creator/*: allow
    /home/ubuntu/.agents/skills/git/git-master/*: allow
    /home/ubuntu/.agents/skills/git/paleontologia/*: allow
    /home/ubuntu/.agents/skills/git/arqueologia/*: allow
    /home/ubuntu/.agents/skills/caveman/caveman-compress/*: allow
    /home/ubuntu/.agents/skills/caveman/caveman-help/*: allow
    /home/ubuntu/.agents/skills/caveman/caveman-review/*: allow
    /home/ubuntu/.agents/skills/caveman/caveman-commit/*: allow
    /home/ubuntu/.agents/skills/caveman/compress/*: allow
    /home/ubuntu/.agents/skills/caveman/caveman/*: allow
    /home/ubuntu/workspace/personal/phardev-agent/.opencode/skills/google-drive-mcp/*: allow
    /home/ubuntu/workspace/personal/phardev-agent/.opencode/skills/notion-mcp/*: allow
    /home/ubuntu/workspace/personal/phardev-agent/.opencode/skills/investigator/document-guide/*: allow
    /home/ubuntu/workspace/personal/phardev-agent/.opencode/skills/investigator/nlm-reference-curator/*: allow
    /home/ubuntu/workspace/personal/phardev-agent/.opencode/skills/investigator/nlm-skill/*: allow
    /home/ubuntu/.local/share/opencode/plans/*: allow
  plan_enter: deny
  repo_clone: deny
  repo_overview: deny
  read:
    "*.env": deny
    "*.env.*": deny
    "*.env.example": allow
    "**/.env": deny
    "**/.env.*": deny
    "**/secrets/**": deny
    "**/credentials.json": deny
  edit:
    "*": deny
    .opencode/plans/*.md: allow
    ../../../.local/share/opencode/plans/*.md: allow
  bash:
    git commit *: allow
    git push *: ask
    git push: ask
    git push --force *: ask
    git rebase *: ask
    git reset --hard *: ask
  task: deny
---

