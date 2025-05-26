import tkinter as tk
from tkinter import messagebox
import subprocess
import threading
import os
import ctypes

# --- CONFIG ---
VISUAL_EXE = "visual.exe"
MOUSE_ERROR_EXE = "mouse_error_thingy.exe"
RANDOM_APPS_BAT = "Open_Random_Apps.bat"
NEGATIVE_SCREEN_EXE = "NegativeScreen.exe"

# --- STATE TRACKING ---
status = {
    "Visual": "OFF",
    "Mouse": "OFF",
    "RandomApps": "OFF",
    "NegativeScreen": "OFF"
}

# --- FUNCTIONS ---
def run_program(path, key):
    def target():
        status[key] = "Opening"
        update_status_window()
        try:
            subprocess.Popen(path)
            status[key] = "Running"
        except Exception:
            status[key] = "OFF"
        update_status_window()
    threading.Thread(target=target).start()
    show_punch_line(f"{key} launched!")

def run_all():
    run_program(VISUAL_EXE, "Visual")
    run_program(MOUSE_ERROR_EXE, "Mouse")
    run_program(RANDOM_APPS_BAT, "RandomApps")
    run_program(NEGATIVE_SCREEN_EXE, "NegativeScreen")

def kill_all():
    def target():
        subprocess.call("taskkill /f /im NegativeScreen.exe", shell=True)
        subprocess.call("taskkill /f /im cmd.exe", shell=True)  # This is now AFTER explorer restart
        # Restart explorer
        subprocess.call("start explorer.exe", shell=True)
        # Now kill everything else
        run_as_admin_batch()
    threading.Thread(target=target).start()

def run_as_admin_batch():
    code = '''
    @echo off
    taskkill /f /im taskmgr.exe
    taskkill /f /im mmc.exe
    taskkill /f /im control.exe
    taskkill /f /im regedit.exe
    taskkill /f /im msconfig.exe
    taskkill /f /im perfmon.exe
    taskkill /f /im notepad.exe
    taskkill /f /im mspaint.exe
    taskkill /f /im explorer.exe
    timeout /t 1 /nobreak >nul
    start explorer.exe
    taskkill /f /im cmd.exe
    exit
    '''
    temp_file = "__admin_killer.bat"
    with open(temp_file, "w") as f:
        f.write(code)
    ctypes.windll.shell32.ShellExecuteW(None, "runas", temp_file, None, None, 1)

def show_punch_line(msg):
    messagebox.showinfo("Hackerman", msg)

status_window = None
status_labels = {}

def update_status_window():
    if status_window:
        for key, label in status_labels.items():
            val = status[key]
            if val == "Running":
                color = "green"
            elif val == "Opening":
                color = "orange"
            else:
                color = "red"
            label.config(text=f"{key}: {val}", fg=color)

def open_status_window():
    global status_window, status_labels
    if status_window and tk.Toplevel.winfo_exists(status_window):
        return
    status_window = tk.Toplevel()
    status_window.title("Process Status")
    status_window.configure(bg="black")
    for i, key in enumerate(status):
        label = tk.Label(status_window, text=f"{key}: {status[key]}", fg="red", bg="black", font=("Consolas", 14))
        label.pack(anchor="w", padx=10, pady=5)
        status_labels[key] = label

# --- GUI ---
root = tk.Tk()
root.title("Hacker Control Center")
root.configure(bg="black")
root.geometry("400x400")

font = ("Consolas", 14)
btn_opt = {"bg": "#111", "fg": "lime", "font": font, "width": 25, "height": 2}

buttons = [
    ("Start Visual", lambda: run_program(VISUAL_EXE, "Visual")),
    ("Start Mouse Glitcher", lambda: run_program(MOUSE_ERROR_EXE, "Mouse")),
    ("Start Random Apps", lambda: run_program(RANDOM_APPS_BAT, "RandomApps")),
    ("Start Negative Screen", lambda: run_program(NEGATIVE_SCREEN_EXE, "NegativeScreen")),
    ("Run All", run_all),
    ("Stop All", kill_all),
    ("Status", open_status_window)
]

for text, command in buttons:
    tk.Button(root, text=text, command=command, **btn_opt).pack(pady=5)

root.mainloop()
