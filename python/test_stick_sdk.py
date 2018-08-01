# frozen_string_literal: true

from stick_sdk import STICK

STICK.init_sdk()
STICK.stop_led_demo()

'''
STICK.write_line(0, [0x000000 for _ in range(32)])
STICK.write_line(1, [0xff0000 for _ in range(32)])
STICK.write_line(2, [0x00ff00 for _ in range(32)])
STICK.write_line(3, [0x0000ff for _ in range(32)])
STICK.write_line(4, [0xff00ff for _ in range(32)])
STICK.write_line(5, [0xffff00 for _ in range(32)])
STICK.write_line(6, [0x00ffff for _ in range(32)])
STICK.write_line(7, [0xffffff for _ in range(32)])
'''
STICK.write_line(0, [0 for _ in range(96)])
STICK.write_line(1, [1 for _ in range(96)])
STICK.write_line(2, [0 for _ in range(96)])
STICK.write_line(3, [1 for _ in range(96)])
STICK.write_line(4, [0 for _ in range(96)])
STICK.write_line(5, [1 for _ in range(96)])
STICK.write_line(6, [0 for _ in range(96)])
STICK.write_line(7, [1 for _ in range(96)])

while True:
    g = STICK.get_accel()
    STICK.show_line(int(g[1]*8.0 / 0x8000)+4)
