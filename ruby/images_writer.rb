# frozen_string_literal: true

require 'RMagick'
include Magick
require_relative './stick_sdk'


STICK.stop_led_demo


parent = '../images/anime2/'
i = 0
Dir.each_child(parent) do |item|
  
  begin
    img = ImageList.new(parent + item).first

    img.columns.times do |x|
      line = []
      img_line = img.get_pixels(x, 0, 1, img.rows)
      img_line.each_with_index do |p, y|
        p  = img.pixel_color(x, y)
        line << p.red << p.green << p.blue
      end
      STICK.write_line(i, line)
      i+=1
    end
  rescue
    next
  end
end

STICK.write_end

puts 'continue to show? (y/n/exit)'
while str = STDIN.gets
    case str.chomp
    when 'exit', 'n'
        exit 0
    when 'y'
        break
    else
    end
end

loop do
  g0 = STICK.get_accel().map { |a| a * 8.0 / 0x8000 }
  line = g0[1].to_i + 4
  STICK.show_line(line)
end