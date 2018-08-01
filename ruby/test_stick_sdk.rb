# frozen_string_literal: true

require './stick_sdk'

STICK.stop_led_demo

STICK.write_line(0, ([1,0,0] * 32).pack('C*'))
STICK.write_line(1, ([0,1,0] * 32).pack('C*'))
STICK.write_line(2, ([0,0,1] * 32).pack('C*'))
STICK.write_line(3, ([1,1,0] * 32).pack('C*'))
STICK.write_line(4, ([0,1,1] * 32).pack('C*'))
STICK.write_line(5, ([1,0,1] * 32).pack('C*'))

loop do
  g = STICK.get_accel()
  g0 = g.map { |a| a * 8.0 / 0x8000 }
  line = g0[1].to_i + 4
  STICK.show_line(line)
end
