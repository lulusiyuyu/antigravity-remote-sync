---
name: Universal Remote Execution
description: A cross-platform active workflow to develop code locally, automatically adapt sync mechanisms (Windows/WSL/Linux), generate a persistent context file, and seamlessly test/execute code on a remote server.
---
# Universal Remote Execution Workflow

**CRITICAL AGENT INSTRUCTIONS:** 
1. **DO NOT MODIFY THIS SKILL FILE (SKILL.md)**. Read it and execute its logic.
2. **Context-Safe Remote Exploration**: When inspecting the remote server (e.g., looking for dataset folders), **NEVER use `tree` or recursive `ls -R`**. Large directories like `data/` will flood the context window and crash the session. Always use shallow exploration like `ls -l` or `find . -maxdepth 1`. You only need a rough idea of the top-level structure.
3. This skill operates in two distinct phases: **[Phase 1] Environment Detection & Setup** and **[Phase 2] Routine Execution**. 
4. The ultimate goal of this workflow is to generate and rely on a `remote_context.md` file in the user's project codebase. Future Agents/Sessions ONLY need to read that context file to perform remote executions smoothly, eliminating the need to ask for passwords or server details repeatedly.

---

## 🛠️ Phase 1: Environment Detection & Setup

*Trigger this phase when the user asks to configure remote execution, or if you need to run code remotely but no `remote_context.md` exists in the local project.*

### Step 1. Check Local Directory & Fetch Remote Project (If Needed)
Check if the local directory is practically empty (e.g., only containing `.git` or `README`). If it is empty:
1. Ask the user: *"Your local directory seems empty. Do you have an existing project on the remote server you want to pull down to start with? If so, please provide the server info and the remote project path."*
2. If the user provides the server info, use SSH to check the size of the first-level folders in their remote directory (e.g., `ssh <user>@<host> "du -sh <remote_path>/*"`).
3. Identify heavy folders (like `dataset/`, `models/`, large `.pt` files, etc.) and propose to the user what should be excluded from the download.
4. Use `scp` (or `rsync --exclude`) to download the core code to the local machine while actively avoiding large files. **IMPORTANT: Ensure future syncs (Local -> Remote) will also be configured to ignore these large chunks, so as not to interact with or overwrite remote model weights.**

If the local directory is NOT empty (or after the above fetch is complete), collect Mission-Critical Information:
- **Target IP / Hostname & SSH Port** (default 22)
- **Username & Authentication Info** (Password, or confirm if SSH Key configured)
- **Target Working Directory** on the Remote Server

*(Note: Strongly encourage the user to configure SSH Keys for a seamless experience on pure Windows, as inline passwords via `scp` are not natively supported without external tools).*

### Step 2. Actively Test the Local Environment
You must autonomously detect the environment you are currently running in. Use terminal commands:
1. **OS Check**: `uname -a` (Linux/WSL) or `systeminfo` / `$PSVersionTable` (Windows).
2. **Tool Check**: Test if `rsync --version`, `git --version`, `ssh -V`, `scp` are available.

### Step 3. Generate the Blueprint (`remote_context.md`)
Using the template at `config/remote_context_template.md`, generate a customized `remote_context.md` file in the root of the user's current project codebase. 
This file MUST contain the precise CLI commands (utilizing the scripts in the `scripts/` folder or native bash/powershell strings) that future agents will run to sync and execute code.

### Step 4. User Notification & Persistent SSH Command
Tell the user two things clearly:
1. *"Setup is complete! I have generated `remote_context.md`. You or any new Agent can now seamlessly sync and execute code just by referring to that context file."*
2. Provide them with a convenient command to manually log into their server for debugging if they need to. Give them the exact one-liner based on their auth type:
   - For Key auth: `ssh -p <PORT> <USER>@<HOST>`
   - For Password auth (if sshpass is available): `sshpass -p '<PASSWORD>' ssh -p <PORT> <USER>@<HOST>`
   - Encourage them to open a new terminal window, paste that command, and keep it alive natively so they can monitor `nvidia-smi` or manually inspect files.

---

## 🚀 Phase 2: Routine Execution (Guided by Context)

*Trigger this phase when a project already has a `remote_context.md`, and the user asks you to "run", "test", or "deploy" the code.*

1. **Read `remote_context.md`** located in the workspace root.
2. Modify the user's codebase locally as requested.
3. Automatically execute the exact **Sync Command** specified in `remote_context.md` to push changes to the server.
4. Automatically execute the exact **Remote SSH Command** specified in `remote_context.md` to trigger the run.
5. Monitor output, parse errors if it fails, debug locally, and repeat the `Sync -> Execute -> Debug` loop unconditionally until the code works.
