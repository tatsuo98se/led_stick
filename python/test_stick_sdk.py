# frozen_string_literal: true

from stick_sdk import STICK

STICK.stop_led_demo()

STICK.write_line(0, [1 for _ in range(32)])
STICK.write_line(1, [1 for _ in range(32)])
STICK.write_line(2, [0 for _ in range(32)])
STICK.write_line(3, [0 for _ in range(32)])
STICK.write_line(4, [0 for _ in range(32)])
STICK.write_line(5, [1 for _ in range(32)])
STICK.write_line(6, [1 for _ in range(32)])
STICK.write_line(7, [1 for _ in range(32)])

while True:
    g = STICK.get_accel()
    STICK.show_line(1)
