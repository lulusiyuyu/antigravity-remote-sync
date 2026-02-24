# 🚀 Remote Execution Context

> **Note for AI Agent:** Read this file carefully. It contains all the exact parameters and commands required to sync the workspace to the remote server and execute code smoothly across platforms. **DO NOT ask the user for these details again. Use the commands exactly as written below.**

## 1. Connection Details
- **Target Host:** `[FILL_HOST_IP_OR_DOMAIN]`
- **Port:** `[FILL_PORT]`
- **Username:** `[FILL_USER]`
- **Authentication Method:** `[SSH_KEY | PASSWORD]`
- **Remote Directory:** `[FILL_REMOTE_DIR]`

## 2. Local Environment Profile
- **Operating System:** `[Windows | WSL | Linux | MacOS]`
- **Chosen Sync Tool:** `[rsync | scp]`

## 3. Standard Operating Procedures (SOP)

### 🔄 A. Code Sync Command
*Agent: Run this specific command in your terminal to push local code to the remote server before any execution.*
```shell
[FILL_EXACT_SYNC_COMMAND_HERE]
# Example (Linux/WSL using script): bash /path/to/sync_linux.sh host 22 user key /remotedir
# Example (Windows using script): powershell -ExecutionPolicy Bypass -File C:\path\to\sync_windows.ps1 -HostName host -Port 22 -User user -Auth key -RemoteDir /remotedir
# Example (Raw sshpass): sshpass -p 'MyPass' rsync -avz -e 'ssh -p 22' ./ user@host:/dir/
` ``

### ▶️ B. Remote Execution Command
*Agent: Run this command to execute the code on the remote machine via SSH and capture the logs.*
```shell
[FILL_EXACT_SSH_COMMAND_HERE]
# Example (Raw SSH Key): ssh -p 22 user@host "cd /dir/ && bash run_task.sh"
# Example (sshpass): sshpass -p 'MyPass' ssh -p 22 user@host "cd /dir/ && python app.py"
` ``

## 4. The Development Loop (Important)
Whenever the user asks you to implement a feature or fix a bug:
1. Write/Edit the code securely in the local environment.
2. Run the **Code Sync Command** (Section 3.A) to overwrite remote files.
3. Run the **Remote Execution Command** (Section 3.B) to execute and check output.
4. If it errors out, read the stack trace, fix the code locally, and repeat Steps 2 and 3 seamlessly.
