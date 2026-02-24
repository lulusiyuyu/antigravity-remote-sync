# AntiGravity Remote Sync (远程无缝执行技能) 🚀

[![Agent Compatible](https://img.shields.io/badge/Agent-AntiGravity-blue.svg)](https://deepmind.google/technologies/gemini/)
[![Platform](https://img.shields.io/badge/Platform-Win%20%7C%20Linux%20%7C%20Mac%20%7C%20WSL-brightgreen.svg)]()
[![License](https://img.shields.io/badge/License-MIT-purple.svg)]()

> A powerful, cross-platform AI Agent skill that effortlessly bridges your local development environment with remote Linux servers. Write code locally, and let **AntiGravity** automatically sync and execute it on the server.
>
> 专为大语言模型 Agent (如 AntiGravity) 设计的跨平台远程同步与执行技能。在本地无感开发，由 Agent 自动推送到远端服务器进行测试与执行。

## 🌟 Introduction (简介)

When building complex applications, websites, or machine learning models, we often face this dilemma: **The local development environment provides the best IDE and coding experience, but execution typically requires a remote server** (whether it's for GPU access, networking, or deploying to a production Linux environment).

This skill provides a structured workflow and script toolkit for an AI Agent to:
1. Detect whether the current environment is Windows, WSL, Linux, or MacOS.
2. Generate a `remote_context.md` that securely stores server information.
3. Automatically sync code to the remote server and run it—creating a seamless local-to-remote execution loop.

当你开发包含网站后端、机器学习等复杂项目时，我们常常面临一个问题：**本地有最好的代码编辑环境，但程序的最终运行却必须依赖远程服务器**（比如需要GPU、特定的网络架构或原生的Linux运行环境）。

这个项目正是为你和你的 AI Agent 准备的通用化自动化工具箱。它能让 Agent：
1. 自动探测你本地系统到底是纯净的 Windows，还是附带了工具链的 WSL / Linux。
2. 自动生成一个配置蓝图（`remote_context.md`），持久化会话记录。
3. 自动根据系统挑选最佳策略，将本地写好的代码一键同步过去并完成运行调试。

---

## ⚠️ READ BEFORE USE: Local First Architecture (必读事项)

**English:**
This workflow operates strictly on a **Local $\rightarrow$ Remote** sync paradigm. **It DOES NOT support syncing files from the Remote server back to Local.**
If you have an existing project on a remote server, **you MUST mutually pull the core code files to your local machine first.** 

**Wait, what about huge files (Datasets, Models, Checkpoints)?**
You **DO NOT** need to download massive files (like large datasets, huge models, or heavy database files) to your local machine. You only need to copy the core logic files. The Agent is smart enough to ssh into your remote directory, examine the file structure (like spotting a `datasets/` folder on the server), and adapt its paths accordingly when writing the code. *(If you are developing a project completely from scratch locally, you can ignore all of this!)*
*(Note: To prevent context overflow, the Agent will only perform a shallow exploration of the first-level directory structure using commands like `ls` rather than full recursive `tree` commands. It only needs to know that a `data/` folder exists, not every single file inside it.)*

**中文:**
本工作流严格遵循 **“本地为主 $\rightarrow$ 推送远端”** 的单向投递机制。**不支持由远端向本地拉取代码的逆向同步！**
如果你的项目代码目前只存放在远程服务器里，**你必须先想办法把核心代码文件拷贝到本地**，然后再挂载本 Skill 帮你在本地继续开发。如果你是从零开始在本地开发一个新项目，那完全不需要管这一步！

**那我服务器上几个 G 的数据集和模型权重也要下载回来吗？**
**完全不需要！** 诸如巨大的 `dataset`、模型 `.pt` / `.safetensors` 等权重文件，不需要搬运到本地，这不仅浪费时间也没有必要。只要把你写业务逻辑的代码拉回来就行。AI Agent 会过去连接你的服务器查勘地形结构（比如它会看到对方那里有个装满数据的 `data/` 目录），并在编写代码时自动把文件路径适配好！
*(注：为了防止大文件目录撑爆上下文，Agent 被严格要求仅会对远端服务器进行第一层目录的概览浅层扫描（使用 `ls` 等非递归命令，**坚决不使用 `tree`**）。它只需要知道存在 `data/` 这样的骨架夹即可，无需深挖内部所有文件，确保你的项目沟通依然健步如飞。)*

---

## 🛠️ Features (主要特性)

- **Universal OS Detection**: Auto-detects pure Windows CMD/PowerShell, WSL, or Linux natively.
- **Smart Fallback Sync**: Uses `rsync` recursively where available (Linux/WSL/GitBash), but gracefully downgrades to standard OpenSSH `scp` on strict Windows configurations.
- **Context Generation**: Automatically drops a `remote_context.md` to hold session commands. **Say goodbye to typing your password 50 times in one dev session!**
- **Hardware Agnostic**: No longer tied specifically to GPUs. Works beautifully for simple Web servers (Nginx/NodeJS/Django) just as well as heavy Deep Learning pipelines.

### 特性说明

*   **全平台盲切**：无论你是没配环境变量的纯 Windows、WSL、还是 Macbook，Agent 会根据环境自动决定运行策略。
*   **智能降级同步机制**：有 Git / rsync 就增量同步；遇到什么都没装的原生 Windows，就自动切成原生 OpenSSH `scp` 强行投递。
*   **一次配置，终身无感**：生成 `remote_context.md` 后，后续再开新的对话让 Agent 跑代码，你都不必重复回答远端服务器 IP 和密码。
*   **不仅仅是 GPU**：从最初只支持显卡训练的任务脱胎换骨，如今无论你在远端挂 Node.js 写前后端，还是配置 Django 都可以完美支持。

---

## 🚀 How to Use (如何使用)

Tell your AI Agent (e.g. AntiGravity):
> _"Please configure the remote server execution for me. Use the AntiGravity Remote Sync skill."_

The Agent will guide you through the process, prompting for necessary details, and initialize the environment!

只需呼叫你的专属 AI 助手：
> _“这项目我想在远程运行，帮我运行一下 AntiGravity 远程同步执行技能”_

Agent 就会自动从询问服务器信息开始，帮你铺垫好通往服务器的高速公路！
