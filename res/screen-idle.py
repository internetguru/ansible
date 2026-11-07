#!/usr/bin/env python3
"""Mac-like idle screen handling for GNOME (Wayland).

After IDLE seconds of inactivity all active displays fade to LEVEL % (via
gamma, so it works on external monitors too) over FADE seconds, stay dimmed
for HOLD seconds and then the screens are turned off. Any input restores
them instantly.

Disable GNOME's own dim/blank first:
  gsettings set org.gnome.desktop.session idle-delay 0
  gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
"""
import argparse
import signal
import sys
import time

from gi.repository import Gio, GLib

IDLE_BUS, IDLE_PATH, IDLE_IFACE = (
    "org.gnome.Mutter.IdleMonitor",
    "/org/gnome/Mutter/IdleMonitor/Core",
    "org.gnome.Mutter.IdleMonitor",
)
DISPLAY_BUS, DISPLAY_PATH, DISPLAY_IFACE = (
    "org.gnome.Mutter.DisplayConfig",
    "/org/gnome/Mutter/DisplayConfig",
    "org.gnome.Mutter.DisplayConfig",
)
SM_BUS, SM_PATH, SM_IFACE = (
    "org.gnome.SessionManager",
    "/org/gnome/SessionManager",
    "org.gnome.SessionManager",
)
RESOURCES_SIG = "(ua(uxiiiiiuaua{sv})a(uxiausauaua{sv})a(uxuudu)ii)"
INHIBIT_IDLE = 8
FADE_STEPS = 20


def log(msg):
    print(time.strftime("%H:%M:%S"), msg, flush=True)


class ScreenIdle:
    def __init__(self, args):
        self.args = args
        self.bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
        self.saved = None  # (serial, {crtc: (r, g, b)}) before dimming
        self.off = False
        self.fade_id = 0
        self.active_watch = 0

        self.bus.signal_subscribe(
            IDLE_BUS, IDLE_IFACE, "WatchFired", IDLE_PATH, None,
            Gio.DBusSignalFlags.NONE, self.on_watch)
        self.dim_watch = self.add_idle_watch(args.idle)
        self.off_watch = self.add_idle_watch(args.idle + args.fade + args.hold)
        log(f"armed: dim after {args.idle}s, off after "
            f"{args.idle + args.fade + args.hold}s")

    # --- D-Bus helpers ---------------------------------------------------
    def call(self, bus, path, iface, method, params=None, reply=None):
        return self.bus.call_sync(
            bus, path, iface, method, params,
            GLib.VariantType(reply) if reply else None,
            Gio.DBusCallFlags.NONE, -1, None)

    def display(self, method, params=None, reply=None):
        return self.call(DISPLAY_BUS, DISPLAY_PATH, DISPLAY_IFACE, method,
                         params, reply)

    def add_idle_watch(self, seconds):
        return self.call(IDLE_BUS, IDLE_PATH, IDLE_IFACE, "AddIdleWatch",
                         GLib.Variant("(t)", (int(seconds * 1000),)), "(u)")[0]

    def read_gamma(self):
        """Gamma ramps of all active CRTCs (those with a current mode)."""
        res = self.display("GetResources", None, RESOURCES_SIG)
        serial = res[0]
        ramps = {}
        for crtc in res[1]:
            if crtc[6] != -1:
                ramps[crtc[0]] = self.display(
                    "GetCrtcGamma", GLib.Variant("(uu)", (serial, crtc[0])),
                    "(aqaqaq)")
        return serial, ramps

    def write_gamma(self, factor):
        serial, ramps = self.saved
        for crtc, (r, g, b) in ramps.items():
            scale = lambda ramp: [int(v * factor) for v in ramp]
            self.display("SetCrtcGamma", GLib.Variant(
                "(uuaqaqaq)", (serial, crtc, scale(r), scale(g), scale(b))))

    def power_save(self, mode):
        self.call(DISPLAY_BUS, DISPLAY_PATH, "org.freedesktop.DBus.Properties",
                  "Set", GLib.Variant("(ssv)", (
                      DISPLAY_IFACE, "PowerSaveMode", GLib.Variant("i", mode))))

    def inhibited(self):
        try:
            return self.call(SM_BUS, SM_PATH, SM_IFACE, "IsInhibited",
                             GLib.Variant("(u)", (INHIBIT_IDLE,)), "(b)")[0]
        except GLib.Error:
            return False

    # --- state machine ---------------------------------------------------
    def on_watch(self, _conn, _sender, _path, _iface, _signal, params):
        watch_id = params[0]
        try:
            if watch_id == self.dim_watch:
                self.dim()
            elif watch_id == self.off_watch:
                self.screen_off()
            elif watch_id == self.active_watch:
                self.active_watch = 0
                self.wake()
        except GLib.Error as e:
            log(f"error: {e.message}")

    def arm_active(self):
        if not self.active_watch:
            self.active_watch = self.call(
                IDLE_BUS, IDLE_PATH, IDLE_IFACE, "AddUserActiveWatch",
                None, "(u)")[0]

    def dim(self):
        if self.off:
            return
        if self.inhibited():
            log("idle inhibited, not dimming")
            return
        if self.saved is None:
            self.saved = self.read_gamma()
        log(f"dim to {self.args.level}% on crtcs {list(self.saved[1])}")
        self.arm_active()
        target = self.args.level / 100
        state = {"i": 0}

        def tick():
            state["i"] += 1
            self.write_gamma(1 - (1 - target) * state["i"] / FADE_STEPS)
            if state["i"] >= FADE_STEPS:
                self.fade_id = 0
                return GLib.SOURCE_REMOVE
            return GLib.SOURCE_CONTINUE

        self.fade_id = GLib.timeout_add(
            int(self.args.fade * 1000 / FADE_STEPS), tick)

    def screen_off(self):
        if self.off or self.saved is None or self.inhibited():
            return
        log("screen off")
        self.off = True
        self.arm_active()
        self.power_save(3)

    def wake(self):
        if self.fade_id:
            GLib.source_remove(self.fade_id)
            self.fade_id = 0
        if self.off:
            self.power_save(0)
            self.off = False
        if self.saved is not None:
            self.write_gamma(1)
            self.saved = None
            log("wake")

    def cleanup(self):
        try:
            self.wake()
        except GLib.Error:
            pass


def main():
    p = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    p.add_argument("--idle", type=float, default=120, help="seconds idle before dimming")
    p.add_argument("--fade", type=float, default=0.5, help="dim fade duration (s)")
    p.add_argument("--hold", type=float, default=20, help="seconds dimmed before screen off")
    p.add_argument("--level", type=int, default=50, help="dim to %% brightness")
    args = p.parse_args()

    daemon = ScreenIdle(args)
    loop = GLib.MainLoop()

    def stop():
        daemon.cleanup()
        loop.quit()
        return GLib.SOURCE_REMOVE

    try:
        from gi.repository import GLibUnix
        add_signal = GLibUnix.signal_add
    except ImportError:
        add_signal = GLib.unix_signal_add
    for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
        add_signal(GLib.PRIORITY_HIGH, sig, stop)
    loop.run()
    return 0


if __name__ == "__main__":
    sys.exit(main())
