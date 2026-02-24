import platform
import sys
import subprocess

def main():
    print("="*50)
    print("🎉 UNIVERSAL REMOTE EXECUTION TEST: SUCCESS 🎉")
    print("="*50)
    
    print(f"📡 Python Version : {sys.version.split(' ')[0]}")
    print(f"💻 Remote OS      : {platform.system()} {platform.release()}")
    print(f"🌐 Hostname       : {platform.node()}")
    print(f"⚙️ Process Arch   : {platform.machine()}")
    
    # Simple check for GPU (Linux)
    if platform.system() == "Linux":
        try:
            print("\n--- GPU Diagnostics ---")
            result = subprocess.run(["nvidia-smi", "--query-gpu=name,memory.total", "--format=csv,noheader"], 
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            if result.returncode == 0:
                print("Detected GPUs:")
                for line in result.stdout.strip().split('\n'):
                    print(f"  - {line}")
            else:
                print("No active NVIDIA GPUs found, or drivers are missing.")
        except FileNotFoundError:
            print("Running in a standard CPU environment (nvidia-smi not available).")
            
    print("="*50)
    print("Your code was written locally, synced seamlessly, and executed remotely!")

if __name__ == "__main__":
    main()
