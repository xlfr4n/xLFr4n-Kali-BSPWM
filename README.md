<div align="center">

# ⚡ xLFr4n / Kali BSPWM 2026

**Un escritorio Kali propio, reproducible y preparado para trabajar en laboratorio.**

<p>
  <a href="https://github.com/xlfr4n/xLFr4n-Kali-BSPWM/actions"><img src="https://img.shields.io/github/actions/workflow/status/xlfr4n/xLFr4n-Kali-BSPWM/shellcheck.yml?label=CI&logo=github&style=for-the-badge" alt="Estado de CI"></a>
  <a href="https://www.kali.org/"><img src="https://img.shields.io/badge/Kali-Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white" alt="Kali Linux"></a>
  <a href="https://github.com/baskerville/bspwm"><img src="https://img.shields.io/badge/BSPWM-X11-252A34?style=for-the-badge" alt="BSPWM en X11"></a>
</p>

<sub>X11 · BSPWM · SXHKD · Polybar · Rofi · Ghostty · tmux · Picom · Dunst</sub>

</div>

---

## Qué es

**Kali BSPWM 2026** es mi configuración de escritorio para Kali Linux. Reúne gestión de ventanas, terminal, lanzadores, notificaciones, nueve espacios de trabajo y utilidades para los laboratorios en una sesión pensada para el uso diario.

Está orientada a una sesión Kali con X11, incluida la ejecución en VirtualBox o VMware. No sustituye al sistema base ni modifica automáticamente el sistema anfitrión. El instalador prepara la configuración del usuario y crea copias de seguridad antes de reemplazar archivos.

## Qué incluye

| Capa | Función |
| --- | --- |
| **Escritorio** | BSPWM, SXHKD y nueve espacios de trabajo. |
| **Barra de estado** | Polybar con información de sesión, objetivo, red y telemetría básica. |
| **Lanzadores** | Rofi, menú xLFr4n y accesos a utilidades habituales. |
| **Terminal** | Ghostty como terminal gráfico compatible, con tmux y zsh. |
| **Dock** | Tint2 como opción preferida, Plank como alternativa y fallback en Polybar. |
| **Sesión** | Picom, Dunst, fondo de pantalla y actualización de monitores. |
| **Laboratorio** | Ayudantes y runbooks para VirtualBox, Active Directory y prácticas web. |

### Identidad visual

**Rojo para la señal · blanco para la información · oscuro para la superficie.**

La idea es tener un entorno de trabajo reconocible sin convertirlo en una colección de efectos: no hay marcos rojos decorativos y las animaciones se mantienen discretas.

## Requisitos

- Kali Linux Rolling.
- Sesión gráfica X11.
- Usuario normal con permisos de `sudo`.
- Conexión a Internet para instalar paquetes y descargar dependencias.

No ejecutes el instalador como `root`.

## Instalación

### Instalación nueva

```bash
cd ~/Downloads
git clone https://github.com/xlfr4n/xLFr4n-Kali-BSPWM.git kali-bspwm-2026
cd kali-bspwm-2026
chmod +x install.sh uninstall.sh
./install.sh
```

Lee la salida del instalador y conserva las copias de seguridad hasta comprobar que la sesión funciona como esperas.

### Desplegar cambios de configuración

Si ya tienes el repositorio actualizado y solo quieres desplegar la configuración:

```bash
cd ~/Downloads/kali-bspwm-2026
./install.sh --deploy
bspc wm -r
```

Este modo despliega la configuración sin ejecutar APT. Actualiza el checkout desde Git cuando decidas incorporar los cambios publicados.

### Actualización completa

```bash
cd ~/Downloads/kali-bspwm-2026
git pull --ff-only origin main
./install.sh
reboot
```

El instalador crea una copia de seguridad antes de reemplazar la configuración del usuario.

## Atajos principales

| Atajo | Acción |
| --- | --- |
| `Super + Enter` | Abrir Ghostty con tmux. |
| `Super + D` | Lanzador de aplicaciones. |
| `Super + Space` | Spotlight. |
| `Super + Shift + Space` | Mission Control. |
| `Super + Shift + H` | Menú xLFr4n. |
| `Super + 1..9` | Cambiar de espacio de trabajo. |
| `Super + Shift + 1..9` | Mover ventana a otro espacio. |
| `Super + Arrow` | Enfocar una ventana en esa dirección. |
| `Super + F` | Pantalla completa. |
| `Super + Shift + W` | Cambiar el fondo aleatoriamente. |
| `Super + Alt + T` | Cambiar tema. |
| `Super + Ctrl + R` | Ejecutar diagnósticos. |
| `Super + Ctrl + X` | Gestionar el objetivo activo. |
| `Super + Shift + K` | Bloquear la sesión. |
| `Super + F1` | Ayuda de atajos. |

La configuración completa de atajos se encuentra en el repositorio y puede variar si personalizas los archivos locales.

## Objetivo de trabajo

El objetivo activo se guarda en `~/.config/polybar/target`.

```bash
settarget 10.10.10.10 Web01
settarget --status
target-copy
cleartarget
```

El módulo de Polybar muestra el objetivo en blanco. La sesión puede emitir un pulso visual breve al inicio, pero el objetivo queda estático después.

## Terminal, dock y temas

Ghostty es el único terminal gráfico admitido por la configuración:

```text
Ghostty → tmux → zsh / herramientas / SSH
```

Comprueba el entorno con:

```bash
xlfr4n-terminal --backend
ghostty --version
tmux -V
```

Kitty no forma parte de la configuración activa. Para consultar o cambiar los temas:

```bash
theme-switch --current
theme-switch --list
theme-switch cyber-red
wallpaper --default
wallpaper --random
wallpaper --next
wallpaper --current
```

Temas incluidos: `cyber-red`, `htb-green`, `nord` y `purple`. Tint2 es el dock preferido; Plank queda como alternativa. La configuración está pensada para que no se ejecuten dos docks a la vez.

## Diagnóstico y pruebas

```bash
doctor.sh
session-profile
bash tests/static.sh
bash tests/shellcheck.sh
```

`doctor.sh` comprueba el estado del entorno sin cambiar la configuración. `session-profile` muestra información de tiempos de inicio a partir del registro de sesión. La CI valida sintaxis de shell y guardas estáticas; el repositorio también mantiene flujos específicos para pruebas de laboratorio.

## Laboratorio aislado

El repositorio incluye documentación y utilidades para trabajar con un entorno de prácticas:

```text
VirtualBox → XLFR4N-LAB → DC01 / WS01 / WEB01
          → snapshots → prácticas AD/Web → evidencias → reset
```

Puntos de entrada:

- `docs/LAB-END-TO-END.md`
- `docs/LAB-STAGES.md`
- `docs/VIRTUALBOX-LAB-TOPOLOGY.md`
- `docs/SNAPSHOT-RESET-RUNBOOK.md`
- `tools/ad-lab/`
- `tools/web-lab/`

## Documentación

- `docs/INSTALL.md` — instalación y resolución de problemas.
- `docs/ARCHITECTURE.md` — capas del sistema.
- `docs/FIRST-VM-TEST.md` — comprobación de la primera máquina virtual.
- `docs/DESKTOP-STYLE.md` — identidad visual.
- `docs/FINAL-AUDIT.md` — auditoría final.
- `docs/VMWARE.md` — integración con VMware.
- `BRAND.md` — identidad del proyecto.

## Seguridad

Este repositorio configura un escritorio y un laboratorio. Realiza prácticas de seguridad solo en sistemas propios o donde tengas autorización expresa. No añadas credenciales, claves privadas, tokens ni datos sensibles reales al repositorio.

<div align="center">

**Terminal primero · Escritorio bajo control · Configuración reproducible**  
<sub>⚡ xLFr4n</sub>

</div>

<details>
<summary><strong>English</strong></summary>

## Overview

Kali BSPWM 2026 is a personal desktop setup for Kali Linux based on X11 and BSPWM. It brings together terminal, window management, launchers, notifications, nine workspaces and lab helpers. It is intended for a real Kali session, including VirtualBox and VMware, and does not automatically modify the host system.

## Install

Run as a regular user, not as root:

```bash
cd ~/Downloads
git clone https://github.com/xlfr4n/xLFr4n-Kali-BSPWM.git kali-bspwm-2026
cd kali-bspwm-2026
chmod +x install.sh uninstall.sh
./install.sh
```

To deploy an already checked-out configuration without running APT:

```bash
./install.sh --deploy
bspc wm -r
```

The installer creates a backup before replacing user configuration. Review its output and keep the backup until the session has been checked.

## Useful commands

```bash
doctor.sh
session-profile
bash tests/static.sh
bash tests/shellcheck.sh
```

Ghostty is the only supported graphical terminal. The project includes theme and wallpaper helpers, target state for Polybar, desktop diagnostics and documentation for isolated AD/Web labs.

## Safety

Use the lab only on systems you own or are authorized to test. Never commit credentials, private keys, webhook secrets or sensitive datasets.

</details>