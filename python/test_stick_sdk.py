# frozen_string_literal: true

from stick_sdk import STICK

STICK.init_sdk()
STICK.stop_led_demo()

STICK.write_line(0, [(0,0,0) for _ in range(32)])
STICK.write_line(1, [(255,0,0) for _ in range(32)])
STICK.write_line(2, [(0,255,0) for _ in range(32)])
STICK.write_line(3, [(0,0,255) for _ in range(32)])
STICK.write_line(4, [(255,0,255) for _ in range(32)])
STICK.write_line(5, [(255,255,0) for _ in range(32)])
STICK.write_line(6, [(0,255,255)for _ in range(32)])
STICK.write_line(7, [(255,255,255) for _ in range(32)])

while True:
    g = STICK.get_accel()
    STICK.show_line(int(g[1]*8.0 / 0x8000)+4)
