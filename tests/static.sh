#!/usr/bin/env bash
# ⚡ xlfr4n // Kali BSPWM 2026
# Static guardrail with explicit diagnostics. No system changes, no runtime dependencies.
# Geometry/UX guardrails follow the current 2026-09-30 desktop layout.
set -Eeuo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

pass=0
fail=0

check() {
  local label="$1"
  shift
  if "$@"; then
    printf "[PASS] %s\n" "$label"
    pass=$((pass + 1))
  else
    printf "[FAIL] %s\n" "$label" >&2
    fail=$((fail + 1))
    return 1
  fi
}

check_not_present() {
  local label="$1"
  shift
  if "$@"; then
    printf "[FAIL] %s\n" "$label" >&2
    fail=$((fail + 1))
    return 1
  else
    printf "[PASS] %s\n" "$label"
    pass=$((pass + 1))
  fi
}

check "syntax install.sh" bash -n install.sh
check "syntax uninstall.sh" bash -n uninstall.sh
check "Uninstall workspace HUD cleanup" grep -Fq 'workspace-hud" --stop' uninstall.sh
check "Uninstall new UX helpers" grep -Fq "audio-control" uninstall.sh
check "Uninstall Fastfetch config" grep -Fq '"$HOME/.config/fastfetch"' uninstall.sh
check "Uninstall launch helper" grep -Fq '"$HOME/.local/bin/xlfr4n-launch"' uninstall.sh
check "Uninstall workspace rail" grep -Fq '"$HOME/.local/bin/workspace-rail"' uninstall.sh
check "Uninstall telemetry pulse" grep -Fq '"$HOME/.local/bin/telemetry-pulse"' uninstall.sh
check "Uninstall target boot state" grep -Fq '"$HOME/.cache/xlfr4n-target-boot-ms"' uninstall.sh
check "syntax bspwmrc" bash -n config/bspwm/bspwmrc
check "syntax polybar launch" bash -n config/polybar/launch.sh

while IFS= read -r -d "" file; do
  check "syntax $file" bash -n "$file"
done < <(find scripts -maxdepth 1 -type f ! -name "README.md" -print0 | sort -z)

required_files=(
  config/bspwm/bspwmrc
  config/sxhkd/sxhkdrc
  config/polybar/config.ini
  config/polybar/launch.sh
  config/ghostty/config
  config/tmux/tmux.conf
  config/fastfetch/config.jsonc
  config/fastfetch/xLFr4n.logo
  config/rofi/launcher.rasi
  config/rofi/menu.rasi
  config/rofi/fallback.rasi
  config/dunst/dunstrc
  config/picom/picom.conf
  config/zshrc
  config/bspwm.desktop
  config/plank/xLFr4n/dock.theme
  config/plank/README.md
  config/tint2/tint2rc
  config/tint2/README.md
  docs/FINAL-AUDIT.md
  scripts/autostart
  scripts/kali-menu
  scripts/rofi-xlfr4n
  scripts/vpn-status
  scripts/vmware-tools
  scripts/doctor.sh
  scripts/xlfr4n-banner
  scripts/xlfr4n-pulse
  scripts/telemetry-pulse
  scripts/launcher-pulse
  scripts/target-pulse
  scripts/xlfr4n-date
  scripts/xlfr4n-launch
  scripts/xlfr4n-terminal
  scripts/install-ghostty
  scripts/xLFr4n-dock-launch
  scripts/target-copy
  scripts/fullscreen-toggle
  scripts/dock
  scripts/mission-control
  scripts/desktop-style
  scripts/session-profile
  scripts/workspace-hud
  scripts/workspace-rail
  scripts/audio-control
  scripts/network-status
  scripts/battery-status
)

for file in "${required_files[@]}"; do
  check "required file: $file" test -s "$file"
done

check "binding: kali-menu" grep -Fq "kali-menu" config/sxhkd/sxhkdrc
check "binding: Rofi drun" grep -Fq "rofi-xlfr4n -show drun" config/sxhkd/sxhkdrc
check "binding: Rofi run" grep -Fq "rofi-xlfr4n -show run" config/sxhkd/sxhkdrc
check "Audio feedback binding" grep -Fq "audio-control up" config/sxhkd/sxhkdrc
check "Brave URL field" grep -Fq "Exec=/usr/local/bin/xLFr4n-dock-launch brave %U" config/applications/xLFr4n-brave.desktop
check "Dock Code launcher file" grep -Fq "Exec=/usr/local/bin/xLFr4n-dock-launch code" config/applications/xLFr4n-code.desktop
check "Dock monitor launcher file" grep -Fq "Exec=/usr/local/bin/xLFr4n-dock-launch btop" config/applications/xLFr4n-btop.desktop
check "Dock settings launcher file" grep -Fq "dock-launch settings" config/applications/xLFr4n-settings.desktop
check "Dock network launcher file" grep -Fq "dock-launch network" config/applications/xLFr4n-network.desktop
check "Dock screenshot launcher file" grep -Fq "dock-launch screenshot" config/applications/xLFr4n-screenshot.desktop
check "Dock Wireshark launcher route" grep -Fq "install_launcher wireshark" scripts/dock
check "Dock Firefox launcher route" grep -Fq "install_launcher firefox" scripts/dock
check "Dock Wireshark route" grep -Fq "wireshark)" scripts/dock-launch
check "Dock Firefox route" grep -Fq "firefox)" scripts/dock-launch
check "VirtualBox service detection" grep -Fq "virtualbox-guest-utils.service" install.sh
check "Fastfetch deployment" grep -Fq "fastfetch; do" install.sh
check "VirtualBox doctor detection" grep -Fq "virtualbox-guest-utils.service" scripts/doctor.sh
check "Polybar restack" grep -Fq "wm-restack = bspwm" config/polybar/config.ini
check "Polybar IPC" grep -Fq "enable-ipc = true" config/polybar/config.ini
check "Polybar transparent top rail" grep -Fq "background = #00000000" config/polybar/config.ini
check "Polybar borderless top rail" grep -Fq "border-size = 0pt" config/polybar/config.ini
check "Polybar width" grep -Fq "width = 94%" config/polybar/config.ini
check "Polybar flat top rail" grep -Fq "radius = 0" config/polybar/config.ini
check "Plank fallback reference" grep -Fq "plank" install.sh
check "Tint2 reference" grep -Fq "tint2" install.sh
check "Rofi fallback reference" grep -Fq "fallback.rasi" scripts/rofi-xlfr4n
check "Workspace bar" grep -Fq "[bar/workspace]" config/polybar/config.ini
check "Workspace modules" grep -Fq "modules-left = bspwm" config/polybar/config.ini
check "Compact workspace labels" grep -Fq "label-focused-margin = 1" config/polybar/config.ini
check "Workspace transparent background" grep -Fq "background = #00000000" config/polybar/config.ini
check "Clock modules" grep -Fq "modules-right = date time" config/polybar/config.ini
check "Workspace launch" grep -Fq "polybar workspace -c" config/polybar/launch.sh
check "Workspace rail at bottom edge" grep -Fq "offset-y = 0pt" config/polybar/config.ini
check "Workspace rail full icon lane" grep -Fq "height = 48pt" config/polybar/config.ini
check "Workspace rail edge offset" grep -Fq "offset-x = 0%" config/polybar/config.ini
check "Dock edge offset" grep -Fq "offset-y = 0pt" config/polybar/config.ini
check "Top rail transparent over framed wallpaper" grep -Fq "background = #00000000" config/polybar/config.ini
check "Top rail geometry" grep -Fq "height = 28pt" config/polybar/config.ini
check "Bottom rail transparent over framed wallpaper" grep -Fq "background = #00000000" config/polybar/config.ini
check "Bottom rail geometry" grep -Fq "height = 48pt" config/polybar/config.ini
check "Wallpaper full bleed" grep -Fq "Full-bleed wallpaper layer" scripts/wallpaper
check "Wallpaper fills screen" grep -Fq "feh --no-fehbg --bg-fill" scripts/wallpaper
check "Wallpaper Kali Hack default" grep -Fq "/usr/share/backgrounds/kali/kali-hack-16x9.jpg" scripts/wallpaper
check "Wallpaper no artificial frame" grep -Fq "No artificial top/bottom black frame" scripts/wallpaper
check "Top Polybar overlay mode" grep -Fq "override-redirect = true" config/polybar/config.ini
check "BSPWM bottom padding reserves metadata lane" grep -Fq "bottom_padding 64" config/bspwm/bspwmrc
check "BSPWM top padding matches rail" grep -Fq "top_padding 38" config/bspwm/bspwmrc
check "Workspace time module" grep -Fq "[module/time]" config/polybar/config.ini
check "Workspace HUD width" grep -Fq "width = 94%" config/polybar/config.ini
check "Workspace click support" grep -Fq "enable-click = true" config/polybar/config.ini
check "Date and time right modules" grep -Fq "modules-right = date time" config/polybar/config.ini
check "Adaptive network module" grep -Fq "exec = ~/.local/bin/network-status" config/polybar/config.ini
check "Optional battery module" grep -Fq "exec = ~/.local/bin/battery-status" config/polybar/config.ini
check "Dock terminal id" grep -Fq "xLFr4n-terminal.desktop" config/tint2/tint2rc
check "Tint2 dock size" grep -Fq "panel_size = 900 72" config/tint2/tint2rc
check "Tint2 no window strut" grep -Fq "strut_policy = follow_size" config/tint2/tint2rc
check "Tint2 dock edge margin" grep -Fq "panel_margin = 0 0" config/tint2/tint2rc
check "Dock code id" grep -Fq "xLFr4n-code.desktop" config/tint2/tint2rc
check "Dock menu id" grep -Fq "xLFr4n-kali-menu.desktop" config/tint2/tint2rc
check "Frameless BSPWM" grep -Fq "border_width 0" config/bspwm/bspwmrc
check "Neutral focused border" grep -Fq "focused_border_color '#262a31'" config/bspwm/bspwmrc
check "Frameless Rofi window" grep -Fq "border: 0px;" config/rofi/launcher.rasi
check "Frameless Tint2" grep -Fq "border_width = 0" config/tint2/tint2rc
check "Frameless Plank" grep -Fq "LineWidth=0" config/plank/xLFr4n/dock.theme
check "Target boot state" grep -Fq "xlfr4n-target-boot-ms" scripts/autostart
check "Target one-shot timing" grep -Fq "elapsed < 1400" scripts/target-pulse
check "Target update cadence" grep -Fq "interval = 1" config/polybar/config.ini
check "Apps static white" grep -Fq 'content = "⌘ APPS"' config/polybar/config.ini
check "Target white rail" grep -Fq "label-foreground = \${colors.fg}" config/polybar/config.ini
check "Fastfetch Kali logo source" grep -Fq '"source": "~/.config/fastfetch/xLFr4n.logo"' config/fastfetch/config.jsonc
check "Fastfetch Kali logo shape" grep -Fq ".............." config/fastfetch/xLFr4n.logo
check "Fastfetch xLFr4n signature" grep -Fq '⚡ xLFr4n' config/fastfetch/xLFr4n.logo
check "Fastfetch Kali blue palette" grep -Fq '"1": "blue"' config/fastfetch/config.jsonc
check "Fastfetch target module" grep -Fq '"key": "TARGET"' config/fastfetch/config.jsonc
check "Fastfetch local IP module" grep -Fq '"type": "localip"' config/fastfetch/config.jsonc
check "Fastfetch date module" grep -Fq '"type": "datetime"' config/fastfetch/config.jsonc
check "Zsh starts Fastfetch" grep -Fq "command -v fastfetch" config/zshrc
check_not_present "Zsh does not auto-start ASCII banner" grep -Fq "xlfr4n-banner --animate" config/zshrc
check "Unified launch feedback helper" grep -Fq "xLFr4n // OPENING" scripts/xlfr4n-launch
check "Launch helper accepts WM class" grep -Fq -- '--class' scripts/xlfr4n-launch
check "Launch notification stack" grep -Fq "x-dunst-stack-tag" scripts/xlfr4n-launch
check "Dock notification stack" grep -Fq "x-dunst-stack-tag" scripts/dock-launch
check "Primary terminal is Ghostty + tmux" grep -Fq 'xlfr4n-launch "Ghostty + tmux"' config/sxhkd/sxhkdrc
check "Terminal helper is Ghostty-only" grep -Fq "Ghostty is the only graphical terminal" scripts/xlfr4n-terminal
check "Terminal helper creates fresh tmux session" grep -Fq 'tmux new-session -s "$tmux_session"' scripts/xlfr4n-terminal
check_not_present "Terminal helper does not auto-attach tmux session" grep -Fq "new-session -A -s" scripts/xlfr4n-terminal
check "Terminal helper uses unique default tmux session" grep -Fq 'xLFr4n-$(date +%Y%m%d-%H%M%S)-$' scripts/xlfr4n-terminal
check "Terminal helper resolves Ghostty" grep -Fq 'GHOSTTY_BIN="${XLFR4N_GHOSTTY_BIN:-}"' scripts/xlfr4n-terminal
check_not_present "Terminal helper has no Kitty fallback" grep -Fiq "kitty" scripts/xlfr4n-terminal
check "tmux is core package" grep -Fq 'network-manager tmux' install.sh
check "Ghostty source bootstrap" test -s scripts/install-ghostty
check "Installer purges legacy Kitty" grep -Fq "legacy_kitty_packages" install.sh
check "Ghostty source version pinned" grep -Fq 'GHOSTTY_VERSION="${XLFR4N_GHOSTTY_VERSION:-1.3.1}"' scripts/install-ghostty
check "Ghostty Zig version pinned" grep -Fq 'ZIG_VERSION="${XLFR4N_GHOSTTY_ZIG_VERSION:-0.15.2}"' scripts/install-ghostty
check "Ghostty official source URL" grep -Fq 'https://release.files.ghostty.org/' scripts/install-ghostty
check "Ghostty Zig official URL" grep -Fq 'https://ziglang.org/download/' scripts/install-ghostty
check "Ghostty source signature check" grep -Fq 'minisign -Vm "$ghostty_archive"' scripts/install-ghostty
check "Installer removes Kitty config" grep -Fq 'rm -rf "$CONFIG_DIR/kitty"' install.sh
check_not_present "Ghostty is not optional" grep -Fq "OPTIONAL_PACKAGES=(ghostty" install.sh
check "Ghostty opaque surface" grep -Fq 'background-opacity = 1.0' config/ghostty/config
check "Ghostty reload binding" grep -Fq 'keybind = ctrl+shift+comma=reload_config' config/ghostty/config
check "Ghostty SSH integration" grep -Fq 'shell-integration-features = ssh-env,ssh-terminfo,no-cursor' config/ghostty/config
check "Ghostty copy shortcut" grep -Fq 'keybind = ctrl+shift+c=copy_to_clipboard' config/ghostty/config
check "Ghostty paste shortcut" grep -Fq 'keybind = ctrl+shift+v=paste_from_clipboard' config/ghostty/config
check "Ghostty select-all shortcut" grep -Fq 'keybind = ctrl+shift+a=select_all' config/ghostty/config
check "Ghostty scrollback top" grep -Fq 'keybind = ctrl+shift+home=scroll_to_top' config/ghostty/config
check "Ghostty scrollback bottom" grep -Fq 'keybind = ctrl+shift+end=scroll_to_bottom' config/ghostty/config
check "Ghostty large scrollback" grep -Fq 'scrollback-limit = 134217728' config/ghostty/config
check "Ghostty explicit selection" grep -Fq 'copy-on-select = false' config/ghostty/config
check "Ghostty Shift mouse selection" grep -Fq 'mouse-shift-capture = never' config/ghostty/config
check "tmux full pane copy" grep -Fq 'capture-pane -JpS - | xclip -selection clipboard -i' config/tmux/tmux.conf
check "tmux no Kitty terminal feature" bash -c '! grep -Fq "xterm-kitty" config/tmux/tmux.conf'
check "Kitty config removed" test ! -e config/kitty/kitty.conf
check "tmux clipboard mode" grep -Fq 'set -s set-clipboard external' config/tmux/tmux.conf
check "tmux mouse copy" grep -Fq 'bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-and-cancel' config/tmux/tmux.conf
check "Ghostty working directory inheritance" grep -Fq 'window-inherit-working-directory = true' config/ghostty/config
check "tmux Ghostty RGB + clipboard" grep -Fq 'terminal-features ",xterm-ghostty:RGB,clipboard"' config/tmux/tmux.conf
check "tmux synchronize panes" grep -Fq 'bind y set-window-option synchronize-panes' config/tmux/tmux.conf
check "dock terminal route" grep -Fq 'dock-launch terminal' config/polybar/config.ini
check "Workspace HUD subscribe" grep -Fq "bspc subscribe desktop_focus" scripts/workspace-hud
check "Workspace HUD stack tag" grep -Fq "x-dunst-stack-tag" scripts/workspace-hud
check "Network follows default route" grep -Fq "ip route show default" scripts/network-status
check "Battery is optional" grep -Fq "BAT*" scripts/battery-status
check "Network state coloring" grep -Fq '%{F%s}%s %s%%{F-}' scripts/network-status
check "Battery state coloring" grep -Fq '%{F%s}%s %s%%{F-}' scripts/battery-status
check "Dock bar" grep -Fq "[bar/dock]" config/polybar/config.ini
check "Dock Polybar backend" grep -Fq "Polybar fallback" scripts/dock
check "Polybar clears stale dock" grep -Fq "stale dock bar" config/polybar/launch.sh
check "Dock Polybar fallback" grep -Fq "polybar-fallback" scripts/dock
check "Dock Tint2 backend" grep -Fq "tint2" scripts/dock
check "Tint2 launcher-only" grep -Fq "panel_items = L" config/tint2/tint2rc
check "Dock launcher helper" grep -Fq "dock-launch" scripts/dock
check "System Monitor launcher" grep -Fq "System Monitor" scripts/dock
check "Screenshot launcher" grep -Fq "screenshot" scripts/dock-launch
check "Nine BSPWM desktops" grep -Fq "bspc monitor -d 1 2 3 4 5 6 7 8 9" config/bspwm/bspwmrc
check "Nine workspace bindings" grep -Fq "super + {1,2,3,4,5,6,7,8,9}" config/sxhkd/sxhkdrc
check_not_present "No nm-applet startup" grep -Fq "command -v nm-applet" scripts/autostart
check "Menu Spotlight" grep -Fq "SPOTLIGHT Launch apps" scripts/kali-menu
check "Menu Mission Control" grep -Fq "MISSION   Window overview" scripts/kali-menu
check "Menu system snapshot" grep -Fq "SYSTEM    Terminal system snapshot" scripts/kali-menu
check "Menu dock" grep -Fq "DOCK      Toggle floating dock" scripts/kali-menu
check "Dock repair action" grep -Fq "REPAIR    Re-sync dock backends" scripts/kali-menu
check "Desktop docs" grep -Fq "xLFr4n" docs/DESKTOP-STYLE.md
check "xLFr4n identity in scripts" grep -Rqs "xlfr4n" scripts --exclude="README.md"
check "Fullscreen binding" grep -Fq "fullscreen-toggle" config/sxhkd/sxhkdrc
check "System snapshot hotkey" grep -Fq "xlfr4n-banner --static" config/sxhkd/sxhkdrc
check "Target clipboard binding" grep -Fq "click-left = target-copy" config/polybar/config.ini
check "Interactive comment paste" grep -Fq "setopt interactivecomments" config/zshrc
check "Fastfetch startup guard" grep -Fq "KALI_BSPWM_FASTFETCH_DONE" config/zshrc
check "Dock launch feedback" grep -Fq "xLFr4n // OPENING" scripts/dock-launch
check "Lab uses xLFr4n banner" grep -Fq "xlfr4n-banner --static" scripts/lab
check "Launcher startup notification" grep -Fq "StartupNotify=true" scripts/dock
check "Banner ASCII frame" grep -Fq "+------------------------------------------------------------------+" scripts/xlfr4n-banner
check "Banner animation" grep -Fq '"BOOT" "LINK" "SYNC" "DRAW" "READY"' scripts/xlfr4n-banner
check "Banner localized clock" grep -Fq "LC_TIME" scripts/xlfr4n-banner
check "Pulse animation reads theme" grep -Fq "theme-state/current" scripts/xlfr4n-pulse
check "Pulse animation keeps xLFr4n identity" grep -Fq "xLFr4n" scripts/xlfr4n-pulse
check "Pulse animation keeps KALI marker" grep -Fq "KALI" scripts/xlfr4n-pulse
check "Identity pulse static" grep -Fq "Static identity helper" scripts/xlfr4n-pulse
check_not_present "Right KALI telemetry disabled" grep -Fq "modules-right = .*telemetry" config/polybar/config.ini
check_not_present "APPS animation disabled" grep -Fq "launcher-pulse" config/polybar/config.ini
check "Target one-shot module" grep -Fq "exec = ~/.local/bin/target-pulse" config/polybar/config.ini
check "Launcher pulse helper" test -s scripts/launcher-pulse
check "Target pulse helper" test -s scripts/target-pulse
check "Identity refresh is low-frequency" grep -Fq "interval = 30" config/polybar/config.ini
check_not_present "KALI right telemetry disabled" grep -Eq "modules-right = .*telemetry" config/polybar/config.ini
check "Localized date helper" grep -Fq "date '+%A, %-d" scripts/xlfr4n-date
check "Spanish date default" grep -Fq 'XLFR4N_DATE_LOCALE:-es' scripts/xlfr4n-date
check "Workspace HUD ready frame" grep -Fq "focus ready" scripts/workspace-hud
check "Workspace rail script" grep -Fq "polybar workspace" scripts/workspace-rail
check "Workspace rail staged after dock" grep -Fq "workspace-rail" scripts/autostart
check "Uninstall date helper" grep -Fq "xlfr4n-date" uninstall.sh
check "Wallpaper fixed default" grep -Fq '/usr/share/backgrounds/kali/kali-hack-16x9.jpg' scripts/wallpaper
check "Wallpaper package dependency" grep -Fq 'kali-wallpapers-2023' install.sh
check "Autostart uses fixed wallpaper" grep -Fq 'wallpaper" --default' scripts/autostart
check "Wallpaper raw override" grep -Fq 'XLFR4N_WALLPAPER_RAW:-0' scripts/wallpaper
check "Polybar fallback dock uses launch helper" grep -Fq "click-left = dock-launch terminal" config/polybar/config.ini
check "Kali Lab shortcut uses launch helper" grep -Fq 'xlfr4n-launch "Kali Lab"' config/sxhkd/sxhkdrc
check "Screenshot menu uses launch helper" grep -Fq 'xlfr4n-launch "Screenshot"' scripts/screenshot-menu

# ── Hardening / regression guards (2026-09-30 review) ─────────────────────
check "syntax brightness-control" bash -n scripts/brightness-control
check "syntax keys-help" bash -n scripts/keys-help
check "Wallpaper temp index is per-process" grep -Fq 'tmp_index="$INDEX_FILE.tmp.$$"' scripts/wallpaper
check_not_present "No predictable /tmp logs in scripts" grep -rqE '/tmp/kali-bspwm' scripts config
check_not_present "No duplicated sxhkd command bindings" bash -c "awk '/^[^[:space:]#]/{k=\$0;next} /^[[:space:]]+[^[:space:]]/{c=\$0; sub(/^[[:space:]]+/,\"\",c); if(c==\"mission-control\"||c==\"theme-switch\")n[c]++} END{exit !(n[\"mission-control\"]>1||n[\"theme-switch\"]>1)}' config/sxhkd/sxhkdrc"
check "Media keys bound" grep -Fq "XF86AudioPlay" config/sxhkd/sxhkdrc
check "Brightness keys bound" grep -Fq "brightness-control up" config/sxhkd/sxhkdrc
check "Keybinding cheat sheet bound" grep -Fq "keys-help" config/sxhkd/sxhkdrc
check "Polkit agent staged in autostart" grep -Fq "polkit" scripts/autostart
check "Idle lock is opt-in" grep -Fq ".config/xlfr4n/autolock" scripts/autostart
check "Keyboard layout configurable" grep -Fq "XLFR4N_KB_LAYOUT" scripts/keyboard
check "Installer skips unavailable extra packages" grep -Fq "EXTRA_PACKAGES" install.sh
check "Zsh completion enabled" grep -Fq "compinit" config/zshrc
check "Zsh syntax-highlighting sourced last" bash -c "tail -n 3 config/zshrc | grep -Fq zsh-syntax-highlighting"
for _s in $(ls scripts | grep -v '^README.md$'); do
  case "$_s" in st|ct) continue ;; esac
  check "Uninstall removes $_s" grep -Fq "\"\$HOME/.local/bin/$_s\"" uninstall.sh
done

check "Brightness targets backlight class" grep -Fq "brightnessctl -c backlight" scripts/brightness-control
check "Brightness is safe without backlight" grep -Fq "! brightnessctl -c backlight get" scripts/brightness-control
check "Brightness helper executable bit" bash -c 'git ls-files --stage scripts/brightness-control | grep -Eq "^100755 .+scripts/brightness-control$"'
check "Keys helper executable bit" bash -c 'git ls-files --stage scripts/keys-help | grep -Eq "^100755 .+scripts/keys-help$"'

printf "\nStatic checks: %d PASS, %d FAIL\n" "$pass" "$fail"
[ "$fail" -eq 0 ]

check "Install guide" test -s docs/INSTALL.md
check "CI workflow least privilege" grep -Fq "contents: read" .github/workflows/shellcheck.yml
check "CI stale run cancellation" grep -Fq "cancel-in-progress: true" .github/workflows/shellcheck.yml
check "CI manual trigger" grep -Fq "workflow_dispatch:" .github/workflows/shellcheck.yml
check "CI desktop validation" grep -Fq "desktop-file-validate" .github/workflows/shellcheck.yml
check "Fast autostart core phase" grep -Fq "phase=core ready" scripts/autostart
check "Autostart dispatches background polish" grep -Fq "phase=background staged" scripts/autostart
check "Autostart stages wallpaper" grep -Fq "nice -n 10" scripts/autostart
check "Autostart avoids startup theme rewrite" grep -Fq "without rewriting any files" scripts/autostart
check_not_present "Autostart does not restart themes" grep -Fq "theme-switch" scripts/autostart
check "Autostart starts Polybar directly" grep -Fq "polybar/launch.sh" scripts/autostart
check "Autostart starts Dunst" grep -Fq "dunst >/dev/null 2>&1 &" scripts/autostart
check "Launch helper guarantees Dunst" grep -Fq "ensure_dunst" scripts/xlfr4n-launch
check "Dock launch helper guarantees Dunst" grep -Fq "ensure_dunst" scripts/dock-launch
check "Autostart starts workspace HUD" grep -Fq 'workspace-hud" --daemon' scripts/autostart
check "Session reload restores workspace rail" grep -Fq 'workspace-rail" --restart' scripts/session-reload
check "Latest session profiler" grep -Fq "most recent xLFr4n session" scripts/session-profile
check "Doctor checks workspace rail" grep -Fq 'Workspace rail' scripts/doctor.sh
check "Autostart single-instance lock" grep -Fq 'flock -n 9' scripts/autostart
check "Autostart user-scoped cleanup" grep -Fq 'pkill -u "$UID"' scripts/autostart
check "Polybar user-scoped cleanup" grep -Fq 'pkill -u "$UID"' config/polybar/launch.sh
check "Dock user-scoped cleanup" grep -Fq 'pkill -u "$UID"' scripts/dock
check "Fullscreen avoids global cleanup" bash -c '! grep -Eq "pkill|killall" scripts/fullscreen-toggle && grep -Fq "bspc node -t \"~fullscreen\"" scripts/fullscreen-toggle'
check "Uninstall user-scoped cleanup" grep -Fq 'pkill -u "$UID"' uninstall.sh
check "Polybar target action opens terminal" grep -Fq 'xlfr4n-terminal --title Kali-Target -- settarget' config/polybar/config.ini
check "Polybar doctor action opens terminal" grep -Fq 'xlfr4n-terminal --title xLFr4n-Doctor -- doctor.sh' config/polybar/config.ini
check "Theme synchronizes Plank" grep -Fq 'PLANK_THEME' scripts/theme-switch
check "Theme feedback mentions Ghostty reload" grep -Fq 'Ctrl+Shift+, to reload' scripts/theme-switch
check "VM-aware Picom backend" grep -Fq 'systemd-detect-virt' scripts/start-picom
check "VirtualBox guest helper" grep -Fq "VIRTUALBOX GUEST" scripts/vmware-tools
check "VMware guest helper" grep -Fq "VMWARE GUEST" scripts/vmware-tools
check "Wallpaper feedback" grep -Fq 'xLFr4n // WALLPAPER' scripts/wallpaper
check "Autostart stages workspace HUD" grep -Fq "workspace hud dispatched" scripts/autostart
check "Lab controller syntax" bash -n scripts/lab
check "Lab engagement initializer" grep -Fq "lab init NAME" scripts/lab
check "Lab scope gate" grep -Fq "scope_matches" scripts/lab
check "Lab target registry" grep -Fq "target add VALUE [NAME]" scripts/lab
check "Lab evidence hashing" grep -Fq "sha256sum" scripts/lab
check "Lab findings" grep -Fq "finding new" scripts/lab
check "Lab report generation" grep -Fq "report_generate" scripts/lab
check "Lab official profiles" grep -Fq "kali-tools-top10" scripts/lab
check "Lab AD profile" grep -Fq "kali-tools-windows-resources" scripts/lab
check "Lab web profile" grep -Fq "kali-tools-web" scripts/lab
check "Polybar engagement status" grep -Fq "lab --status-short" config/polybar/config.ini
check "Polybar engagement interval" grep -Fq "interval = 2" config/polybar/config.ini
check "Menu engagement status" grep -Fq "LABSTATUS" scripts/kali-menu
check "CI jq dependency" grep -Eq "apt-get install .*jq" .github/workflows/shellcheck.yml

check "Lab smoke test" test -x tests/lab-smoke.sh
check "CI lab smoke step" grep -Fq "bash tests/lab-smoke.sh" .github/workflows/shellcheck.yml
check "CI shellcheck smoke script" grep -Fq "shellcheck tests/lab-smoke.sh" .github/workflows/shellcheck.yml

check "Bottom dock icon size" grep -Fq "launcher_icon_size = 52" config/tint2/tint2rc
check "Fallback dock icon size" grep -Fq 'icon-size 52' scripts/dock

check "VPN helper" test -s scripts/vpn-status
check "VPN module uses helper" grep -Fq 'exec = ~/.local/bin/vpn-status' config/polybar/config.ini
check "VPN stale tunnel guard" grep -Fq "pgrep -af '[o]penvpn'" scripts/vpn-status
check "Target empty is hidden" grep -Fq "Empty target = no module at all" scripts/target-pulse
check "Command palette theme" test -s config/rofi/menu.rasi
check "Command palette routing" grep -Fq "MENU_THEME=" scripts/rofi-xlfr4n
check "Menu desktop action" grep -Fq "DESKTOP" scripts/kali-menu
check "Menu ZAP routing" grep -Fq "ZAPROXY" scripts/kali-menu
check "Screenshot clipboard actions" grep -Fq "REGION-CLIP" scripts/screenshot-menu
check "Screenshot folder action" grep -Fq 'xdg-open "$SCREENSHOT_DIR"' scripts/screenshot-menu
check "Plank animation disabled" grep -Fq "LaunchBounceHeight=0" config/plank/xLFr4n/dock.theme
check "Plank zoom disabled" grep -Fq 'zoom-enabled false' scripts/dock
check "Tint2 startup notifications disabled" grep -Fq "startup_notifications = 0" config/tint2/tint2rc
check "VPN helper uninstall" grep -Fq 'vpn-status' uninstall.sh
