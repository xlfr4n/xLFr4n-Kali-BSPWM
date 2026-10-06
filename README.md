# ⚡ xLFr4n // Kali BSPWM 2026

> **Kali Linux · X11 · BSPWM · SXHKD · Polybar · Rofi · Ghostty · tmux · Picom · Dunst**
>
> Personal, reproducible and VM-friendly desktop layer by **xLFr4n**.

<p align="center">
[![CI](https://img.shields.io/github/actions/workflow/status/xlfr4n/xLFr4n-Kali-BSPWM/shellcheck.yml?label=CI&logo=github)](https://github.com/xlfr4n/xLFr4n-Kali-BSPWM/actions) 
[![Kali](https://img.shields.io/badge/Kali-Linux-557C94?style=flat-square&logo=kalilinux&logoColor=white)](https://www.kali.org/) 
[![BSPWM](https://img.shields.io/badge/BSPWM-X11-111827?style=flat-square)](https://github.com/baskerville/bspwm)
</p>

## 🇪🇸 Español

### 🎯 Qué es

Kali BSPWM 2026 es la capa de escritorio personal de **xLFr4n** para Kali Linux. Mantiene una base ligera sobre X11 + BSPWM y añade una interfaz operativa alrededor de terminal, ventanas, lanzadores, notificaciones, workspace, target y herramientas de laboratorio.

El proyecto está pensado para una sesión Kali real, especialmente dentro de VirtualBox o VMware. No intenta sustituir el sistema base ni modificar automáticamente el host.

### 🧭 Qué aporta

| Área | Función |
|---|---|
| 🐧 Desktop | BSPWM + SXHKD + 9 workspaces |
| 📊 Status | Polybar con identidad, target, red y telemetría básica |
| 🧊 Dock | Tint2 launcher-only con fallback Plank |
| ⌨️ Terminal | Ghostty como único terminal gráfico + tmux |
| 🎛️ Control | Rofi, menú xLFr4n, power/network/monitor helpers |
| 🎯 Target | estado local, copia al clipboard y feedback de sesión |
| 🔔 UX | Dunst + helpers ligeros |
| 🧪 Lab | AD, Web Lab, VirtualBox y runbooks |

### 🎨 Contrato visual

**rojo = señal** · **blanco = información** · **oscuro = superficie** · **sin marcos rojos decorativos**

El objetivo es que el escritorio se sienta como un sistema de trabajo, no como una colección de efectos.

### 🇬🇧 English

Kali BSPWM 2026 is the **xLFr4n** personal desktop layer for Kali Linux. It keeps a lightweight X11 + BSPWM base and adds an operational interface around terminal, windows, launchers, notifications, workspaces, target state and lab tooling.

It is designed for a real Kali session, especially inside VirtualBox or VMware. It does not replace the base system and does not automatically modify the host.

### 🎨 Visual contract

**red = signal** · **white = information** · **dark = surface** · **no decorative red window frames**

---

# 🚀 Installation

## 🇪🇸 Español

### Requisitos

- Kali Linux Rolling
- sesión X11
- usuario normal con sudo
- arquitectura compatible con los paquetes del proyecto

### Instalación nueva

~~~bash
cd ~/Downloads
git clone https://github.com/xlfr4n/xLFr4n-Kali-BSPWM.git kali-bspwm-2026
cd kali-bspwm-2026
chmod +x install.sh uninstall.sh
./install.sh
~~~

No ejecutes el instalador como root.

### Actualización rápida

~~~bash
cd ~/Downloads/kali-bspwm-2026
git pull --ff-only origin main
./install.sh --deploy
bspc wm -r
~~~

`git pull` actualiza el checkout; `--deploy` despliega la configuración sin ejecutar APT.

### Actualización completa

~~~bash
cd ~/Downloads/kali-bspwm-2026
git pull --ff-only origin main
./install.sh
reboot
~~~

El instalador crea un backup antes de reemplazar la configuración del usuario.

## 🇺🇸 English

Fresh install:

~~~bash
cd ~/Downloads
git clone https://github.com/xlfr4n/xLFr4n-Kali-BSPWM.git kali-bspwm-2026
cd kali-bspwm-2026
chmod +x install.sh uninstall.sh
./install.sh
~~~

Fast configuration deploy:

~~~bash
cd ~/Downloads/kali-bspwm-2026
git pull --ff-only origin main
./install.sh --deploy
bspc wm -r
~~~

Full update:

~~~bash
cd ~/Downloads/kali-bspwm-2026
git pull --ff-only origin main
./install.sh
reboot
~~~

The installer creates a timestamped backup before replacing user configuration.

---

# 🧱 Architecture

~~~text
Display Manager
      ↓
     X11
      ↓
    BSPWM
      ↓
  autostart
      ├── SXHKD
      ├── Dunst
      ├── Polybar
      ├── monitor-refresh
      ├── desktop-style
      ├── wallpaper
      ├── dock
      └── Picom
~~~

| Layer | Responsibility |
|---|---|
| `config/` | reproducible desktop configuration |
| `scripts/` | runtime helpers and operational controls |
| `docs/` | install, architecture, VM and lab runbooks |
| `tests/` | static guards and ShellCheck |
| `tools/` | AD, Web Lab and VirtualBox helpers |

---

# ⌨️ Shortcuts

| Key | Action |
|---|---|
| Super + Enter | Ghostty + tmux |
| Super + D | application launcher |
| Super + Space | Spotlight |
| Super + Shift + Space | Mission Control |
| Super + Shift + H | xLFr4n menu |
| Super + Shift + A | dock |
| Super + 1..9 | focus workspace |
| Super + Shift + 1..9 | move window to workspace |
| Super + Arrow | focus direction |
| Super + Shift + Arrow | swap window |
| Super + Alt + Arrow | resize |
| Super + F | fullscreen |
| Super + Shift + W | random wallpaper |
| Super + Alt + T | themes |
| Super + Shift + M | monitor refresh |
| Super + Ctrl + R | doctor |
| Super + Ctrl + X | target |
| Super + Shift + S | screenshot menu |
| Super + Shift + K | lock |
| Super + F1 | shortcut help |

---

# 🎯 Target

Target state lives in `~/.config/polybar/target`.

~~~bash
settarget 10.10.10.10 Web01
settarget --status
target-copy
cleartarget
~~~

The Polybar target module is white. A short one-shot session pulse runs during startup; after that, the displayed target remains static.

---

# 🧊 Dock

Tint2 is the preferred launcher-only backend. Plank is the optional fallback.

~~~text
Tint2 → Plank → Polybar fallback
~~~

Only one dock backend is intended to run at a time. Application launchers use the xLFr4n helper layer to prefer focusing an existing window where possible.

---

# 🎨 Themes & wallpaper

Available themes:

`cyber-red` · `htb-green` · `nord` · `purple`

~~~bash
theme-switch --current
theme-switch --list
theme-switch cyber-red
wallpaper --default
wallpaper --random
wallpaper --next
wallpaper --current
~~~

The current wallpaper helper keeps its default source configurable via `XLFR4N_DEFAULT_WALLPAPER` and caches prepared variants when ImageMagick is available.

---

# 🖥️ Terminal

Ghostty is the only supported graphical terminal.

~~~text
Ghostty → tmux → zsh / tooling / SSH
~~~

Check the backend:

~~~bash
xlfr4n-terminal --backend
ghostty --version
tmux -V
~~~

Kitty is intentionally not part of the runtime configuration.

---

# 🩺 Diagnostics

~~~bash
doctor.sh
session-profile
~~~

`doctor.sh` is intended as a read-only health check for the desktop layer. `session-profile` reads the session log to show staged startup timing.

---

# 🧪 Tests

~~~bash
bash tests/static.sh
bash tests/shellcheck.sh
~~~

CI validates shell syntax/guards and the repository keeps VM/lab smoke coverage in dedicated workflows.

---

# 🟥 Red Team Lab

The repository also contains the operational path for an isolated practice environment:

**VirtualBox → XLFR4N-LAB → DC01 / WS01 / WEB01 → snapshots → AD/Web exercises → evidence → reporting → reset**

Useful entry points:

- `docs/LAB-END-TO-END.md`
- `docs/LAB-STAGES.md`
- `docs/VIRTUALBOX-LAB-TOPOLOGY.md`
- `docs/SNAPSHOT-RESET-RUNBOOK.md`
- `tools/ad-lab/`
- `tools/web-lab/`

---

# 📚 Documentation

- `docs/INSTALL.md` — installation and troubleshooting
- `docs/ARCHITECTURE.md` — system layers
- `docs/FIRST-VM-TEST.md` — first VM validation
- `docs/DESKTOP-STYLE.md` — visual contract
- `docs/FINAL-AUDIT.md` — final audit
- `docs/LAB-END-TO-END.md` — end-to-end lab flow
- `docs/VMWARE.md` — VMware integration
- `BRAND.md` — project identity

---

# 🔐 Safety

This project is a desktop and lab environment. Security exercises should remain inside systems you own or are explicitly authorized to test.

Do not place credentials, private keys, webhook secrets or real sensitive datasets in the repository.

<p align="center"><strong>⚡ xLFr4n</strong><br><sub>Terminal first · Desktop owned · Reproducible always</sub></p>