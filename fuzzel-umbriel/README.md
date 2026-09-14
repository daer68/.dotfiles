# fuzzel-umbriel

`umbriel-fuzzel` — a [fuzzel](https://codeberg.org/dnkl/fuzzel)-driven application
launcher for the [Umbriel](https://github.com/noctalia-dev/umbriel) compositor,
with focus-or-spawn built in. Selecting an app that is already running focuses
it instead of starting a second copy.

```bash
stow -t ~ fuzzel-umbriel
```

Installs `~/.local/bin/umbriel-fuzzel`. Bound to `Mod+D` by the `umbriel`
package (`umbriel/.config/umbriel/binds.toml`), which invokes it by absolute
path — `~/.local/bin` is not on the login `PATH`.

## Requirements

| Dependency | Used for |
| --- | --- |
| `fuzzel` | The picker itself, in `--dmenu` mode |
| `umbriel` | `umbriel windows --json`, `umbriel msg spawn:` |
| `umbriel-raise` | Focus-or-launch dispatch, expected at `~/.local/bin/umbriel-raise` |
| PyGObject (`python-gobject`) | `Gio.AppInfo` desktop-entry enumeration, `GLib.shell_parse_argv` |

`umbriel-raise` is built from [daer68/umbriel-raise](https://github.com/daer68/umbriel-raise)
and is not tracked here.

## Behavior

The menu is built by hand rather than using fuzzel's own application mode. Every
visible `.desktop` entry is read through `Gio.AppInfo`; `Exec` is stripped of
field codes (`%f`, `%U`, …) and flatpak `@@u … @@` forwarding, then parsed with
`GLib.shell_parse_argv`. Entries marked `Terminal=true` are wrapped in
`$TERMINAL -e` (default `kitty`). Icons survive via fuzzel's Rofi-style extended
dmenu protocol.

| Input | Result |
| --- | --- |
| `Enter` | Focus the running instance if there is one, else launch it |
| `Ctrl+Enter` / `Alt+1` | Always spawn a new instance, skipping the focus check |
| Text matching no entry | Spawned verbatim through `umbriel msg spawn:` |

`Ctrl+Enter` depends on `custom-1` being bound in the `fuzzel` package's
`fuzzel.ini`; fuzzel leaves it unbound by default.

### App ID resolution

`umbriel-raise` matches `app_id` exactly, but a desktop entry implies several
plausible runtime IDs and only one tends to be real — `StartupWMClass` matches
for some apps (Spotify), while others (flatpak'd Zen Browser) only match their
flatpak ref or desktop-file ID. All three candidates are collected, and
whichever one `umbriel windows --json` reports as currently open wins. When none
is open the first guess is used, where matching nothing is the correct outcome
and `umbriel-raise` spawns.

## State

Frecency ordering is kept by fuzzel at `~/.cache/umbriel-fuzzel/dmenu.cache`,
separate from the cache of a plain `fuzzel` invocation.
