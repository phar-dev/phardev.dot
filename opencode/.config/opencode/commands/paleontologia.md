---
description: Investigate commits related to a specific topic and summarize changes and objectives
skills:
  - git-master
---

Load the git-master skill first, then:

Perform a detailed paleontology/archaeology investigation of commits related to the topic: **$ARGUMENTS**

Use git commands to search, analyze, and summarize:

1. **Search for relevant commits**:
   - Use `git log --all --oneline --grep="$ARGUMENTS"` to find commits with this topic in the message
   - Use `git log --all --oneline -S"$ARGUMENTS"` to find commits that introduced/removed this content
   - Use `git log --all --oneline --author="$ARGUMENTS"` to find commits by this author (if applicable)

2. **Analyze commit details**:
   - Show commit hash, date, author, and full message for each relevant commit
   - Use `git show` or `git log -p` to see the actual changes
   - Identify which files were modified

3. **Summarize findings**:
   - **Timeline**: When were the changes made?
   - **What changed**: List the key files and modifications
   - **Why changed**: Extract the objective or reason from commit messages
   - **Pattern recognition**: Identify if there's a series of related commits

4. **Present as a structured report**:
   - Brief overview of what this topic covers in the repo
   - Chronological summary of key commits
   - Detailed analysis of the most important changes
   - Any patterns or trends identified

Focus on providing context and understanding of how this topic evolved in the repository, not just raw commit data.
