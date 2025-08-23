#!/usr/bin/env python3
import os, pyperclip, pyautogui
print("NovaMind AI Panel. Команди: 'відкрий <app>', 'напиши <текст>', 'курсор X,Y', 'закрий вікно', 'вихід'")
while True:
    try:
        cmd = input("> ").strip()
    except EOFError:
        break
    low = cmd.lower()
    if low == "вихід": break
    elif low.startswith("відкрий "):
        os.system(low.replace("відкрий ","")+" &")
    elif low.startswith("напиши "):
        t = cmd[7:]; pyperclip.copy(t); pyautogui.hotkey("ctrl","v")
    elif low.startswith("курсор "):
        try:
            x,y = low.replace("курсор ","").split(","); pyautogui.moveTo(int(x),int(y),0.3)
        except: print("формат: курсор X,Y")
    elif low == "закрий вікно":
        pyautogui.hotkey("alt","f4")
    else:
        print("Невідома команда")
