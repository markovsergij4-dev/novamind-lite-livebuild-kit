#!/usr/bin/env python3
import os, sys, time

def ensure_deps():
    try:
        import pyautogui, pyperclip  # noqa
    except Exception:
        os.system("python3 -m pip install --no-input --break-system-packages pyautogui pyperclip >/dev/null 2>&1 || python3 -m pip install --no-input pyautogui pyperclip >/dev/null 2>&1")

def main():
    import pyautogui, pyperclip
    print("=== NovaMind AI Panel (text) ===")
    print("Команди: 'відкрий <app>', 'напиши <текст>', 'курсор X,Y', 'закрий вікно', 'вихід'")
    while True:
        try:
            cmd = input("> ").strip()
        except EOFError:
            break
        if not cmd:
            continue
        low = cmd.lower()

        if low == "вихід":
            print("Bye."); break
        elif low.startswith("відкрий "):
            app = cmd[7:].strip()
            os.system(f"{app} &")
            print(f"[AI] Відкриваю: {app}")
        elif low.startswith("напиши "):
            text = cmd[7:].strip()
            pyperclip.copy(text); pyautogui.hotkey("ctrl","v")
            print(f"[AI] Надрукував: {text}")
        elif low.startswith("курсор "):
            try:
                x,y = low[7:].replace(" ","").split(",")
                pyautogui.moveTo(int(x),int(y),duration=0.3)
                print(f"[AI] Курсор → ({x},{y})")
            except: print("Формат: 'курсор X,Y'")
        elif low == "закрий вікно":
            pyautogui.hotkey("alt","f4"); print("[AI] Закрив активне вікно")
        else:
            print("Невідома команда.")

if __name__ == "__main__":
    ensure_deps(); main()
