# NovaMind Lite OS — Live USB (GitHub Actions ready)

Готовий каркас для збірки Live ISO з двома режимами (XFCE/KDE), AI‑панеллю та persistence‑скриптами.

## Локальна збірка
```bash
chmod +x build.sh
./build.sh
```

## Запис ISO на USB
- Windows: Rufus → вибери ISO → USB → (MBR для старих ПК). Якщо є *Persistent storage* — обери обсяг.
- Linux/macOS: balenaEtcher. Для ручного persistence виконай:
```
sudo bash tools/create_persistence_auto.sh
# або
sudo bash tools/create_persistence_on_device.sh /dev/sdX
```

## Автовибір інтерфейсу
- <4 ГБ RAM → XFCE
- ≥4 ГБ RAM → KDE
AI‑панель відкриється терміналом. Команди:
```
відкрий firefox-esr
напиши Привіт, NovaMind!
курсор 600,300
закрий вікно
```

## GitHub Actions
Workflow вже включений у `.github/workflows/build-novamind.yml`.
