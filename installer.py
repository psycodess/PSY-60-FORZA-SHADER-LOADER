import os
import sys
import time
import shutil
import urllib.request
import subprocess
import webbrowser

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def print_rainbow_ascii():
    ascii_art = """
  _____   _____ __     __       __    ___  
 |  __ \ / ____|\ \   / /      / /   / _ \ 
 | |__) | (___   \ \_/ /____  / /_  | | | |
 |  ___/ \___ \   \   /|____|| '_ \ | | | |
 | |     ____) |   | |       | (_) || |_| |
 |_|    |_____/    |_|        \___/  \___/ 
    """
    colors = [
        "\033[38;5;196m", # Red
        "\033[38;5;208m", # Orange
        "\033[38;5;226m", # Yellow
        "\033[38;5;46m",  # Green
        "\033[38;5;21m",  # Blue
        "\033[38;5;93m",  # Indigo
        "\033[38;5;201m"  # Violet
    ]
    
    lines = ascii_art.strip('\n').split('\n')
    for i, line in enumerate(lines):
        color = colors[i % len(colors)]
        print(color + line + "\033[0m")
        
    print("\n" + "\033[38;5;51m" + "="*50)
    print(" Developer: PSYCHOWHO / SIFAT")
    print(" Project: PSY-60-FORZA-SHADER-LOADER")
    print("="*50 + "\033[0m\n")

def download_and_install_reshade():
    print("\033[38;5;226m" + "[*] Downloading ReShade Setup..." + "\033[0m")
    reshade_url = "https://reshade.me/downloads/ReShade_Setup_6.7.3.exe"
    setup_file = "ReShade_Setup.exe"
    try:
        urllib.request.urlretrieve(reshade_url, setup_file)
        print("\033[38;5;46m" + "[+] Download complete!" + "\033[0m")
        print("\033[38;5;226m" + "[*] Launching ReShade installer... Please follow the on-screen instructions." + "\033[0m")
        subprocess.run([setup_file])
        print("\033[38;5;46m" + "[+] ReShade installation finished." + "\033[0m")
        if os.path.exists(setup_file):
            try:
                os.remove(setup_file)
            except:
                pass
    except Exception as e:
        print("\033[38;5;196m" + f"[-] Failed to download/install ReShade: {e}" + "\033[0m")
        print("\033[38;5;226m" + "[*] Opening ReShade website instead..." + "\033[0m")
        webbrowser.open("https://reshade.me/")
        input("Please download and install ReShade manually, then press Enter to continue...")

def copy_shaders(game_path):
    if getattr(sys, 'frozen', False):
        # If the application is run as a bundle/executable
        repo_path = os.path.dirname(sys.executable)
    else:
        # If the application is run as a python script
        repo_path = os.path.dirname(os.path.abspath(__file__))
        
    src_reshade_folder = os.path.join(repo_path, "reshade-shaders")
    
    if not os.path.exists(src_reshade_folder):
        print("\033[38;5;196m" + "[-] 'reshade-shaders' folder not found in the current directory!" + "\033[0m")
        return False

    dst_reshade_folder = os.path.join(game_path, "reshade-shaders")
    
    print("\033[38;5;226m" + f"[*] Copying shaders to: {dst_reshade_folder}" + "\033[0m")
    try:
        # We copy the contents inside reshade-shaders to the game path, and optionally to game_path\reshade-shaders
        # The user said "paste that reshade folder reset shader folder from this repository to the but they have given and override if any existing files are there"
        # We will copy the directory structure as it is into game_path\reshade-shaders
        if os.path.exists(dst_reshade_folder):
            shutil.rmtree(dst_reshade_folder)
        shutil.copytree(src_reshade_folder, dst_reshade_folder)
        
        # In ReShade, presets (.ini) are often stored next to the game exe. Let's copy the .ini files from the repo's reshade-shaders folder directly into the game_path as well.
        for item in os.listdir(src_reshade_folder):
            item_path = os.path.join(src_reshade_folder, item)
            if os.path.isfile(item_path):
                shutil.copy2(item_path, os.path.join(game_path, item))
                
        print("\033[38;5;46m" + "[+] Shaders copied successfully!" + "\033[0m")
        return True
    except Exception as e:
        print("\033[38;5;196m" + f"[-] Error copying files: {e}" + "\033[0m")
        return False

def main():
    if os.name == 'nt':
        os.system('color') # Enable ANSI escape characters in Windows CMD
    clear_screen()
    print_rainbow_ascii()
    
    # 1. Ask about ReShade
    while True:
        ans = input("\033[38;5;255m" + "Do you have ReShade installed? (Y/N): " + "\033[0m").strip().lower()
        if ans in ['y', 'yes']:
            break
        elif ans in ['n', 'no']:
            download_and_install_reshade()
            break
        else:
            print("\033[38;5;196m" + "Invalid input. Please enter Y or N." + "\033[0m")

    # 2. Ask for game path
    while True:
        game_path = input("\033[38;5;255m" + "\nPlease enter the specific path where the game is installed:\n> " + "\033[0m").strip()
        game_path = game_path.strip('"').strip("'")
        if os.path.exists(game_path):
            break
        else:
            print("\033[38;5;196m" + "[-] The specified path does not exist. Please try again." + "\033[0m")

    # 3. Copy shaders
    success = copy_shaders(game_path)
    
    if success:
        print("\n\033[38;5;46m" + "=====================================================")
        print(" SUCCESS! Everything has been installed successfully.")
        print("=====================================================" + "\033[0m\n")
        
    print("\033[38;5;201m" + "[*] Opening Instagram..." + "\033[0m")
    time.sleep(2)
    webbrowser.open("https://www.instagram.com/psychowhoqustionmark/")
    
    input("\033[38;5;255m" + "\nPress Enter to exit..." + "\033[0m")

if __name__ == "__main__":
    main()
