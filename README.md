# wayland-autoclicker

A dead-simple autoclicker for Wayland desktops, built on [`ydotool`](https://github.com/ReimuNotMoe/ydotool) since `xdotool` and other X11-based clickers don't work under Wayland's input security model.

Tested on CachyOS + KDE Plasma (KWin/Wayland), but should work on any Wayland compositor since `ydotool` operates at the kernel `uinput` level rather than talking to the display server directly.

## How it works

- Toggles on/off with a single hotkey press
- Uses `flock` to guarantee only one clicking loop can ever run at a time no PID tracking, no signal races
- Stopping is done by dropping a flag file the loop checks every iteration, so it can't get "stuck" the way PID/kill-based approaches can

## Quick setup

```bash
git clone https://github.com/oclunny/wayland-autoclicker.git
cd wayland-autoclicker
./install.sh
```

The installer will:
1. Install `ydotool` if it's missing (supports `yay`, `pacman`, or `apt`)
2. Copy `autoclicker.sh` to `~/.local/bin/`
3. Add your user to the `input` group (required for `uinput` access)
4. Enable and start the `ydotool.service` user daemon

If your user was just added to the `input` group, **log out and back in** before testing group membership only takes effect on a fresh login.

Then verify it works standalone:
```bash
ydotool click 0xC0
```
If your cursor position registers a click, you're good.

## Bind it to a hotkey

### KDE Plasma
1. **System Settings → Shortcuts → Custom Shortcuts**
2. Right-click → **New → Global Shortcut → Command/URL**
3. Set the command to: `~/.local/bin/autoclicker.sh`
4. Set the trigger to a free key — avoid bare modifier keys like `Alt` alone, they don't register reliably as a standalone trigger. A free function key like `F8` works well.

### GNOME
**Settings → Keyboard → Keyboard Shortcuts → Custom Shortcuts → Add**, point it at `~/.local/bin/autoclicker.sh`, set your key.

### Other desktop environments
Bind the script to a custom keyboard shortcut using whatever your DE's shortcut settings provide any DE that can run an arbitrary command on a hotkey works.

## Usage

Press your hotkey once → clicking starts at the current cursor position, roughly 16 clicks/sec by default.
Press it again → clicking stops.

## Configuration

Edit the variables at the top of `~/.local/bin/autoclicker.sh`:

```bash
INTERVAL=0.06   # seconds between clicks (lower = faster)
BUTTON=0xC0     # 0xC0 = left click; see ydotool docs for other buttons
```

## Emergency stop

If the hotkey ever seems unresponsive, this always works immediately from any terminal:

```bash
touch /tmp/.autoclicker.stop
```

## Requirements

- A Wayland session (this is the whole point — for X11 there are many existing tools already)
- [`ydotool`](https://github.com/ReimuNotMoe/ydotool)
- `systemd --user` support (used to run `ydotoold`)

## License

MIT
