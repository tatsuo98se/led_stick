# frozen_string_literal: true

require 'rmagick'
include Magick
require_relative './stick_sdk'
require_relative './btn_handler'

STICK.stop_led_demo

parent = '../animations/'

switch_state = false

btn_handler = ButtonHandler.new
btn_handler.handle_button_down do 
  switch_state = true
end

loop do
  Dir.foreach(parent).sort.each do |childdir|
    next unless childdir.start_with? 'anime' 

    i = 0
    image_count = 0
    last_index = 0
    last_colmuns = 0

    Dir.foreach(File.join(parent, childdir)).sort.each do |item|
      begin
        img = ImageList.new(File.join(parent, childdir, item)).first
        if last_colmuns == 0 then
          last_colmuns = img.columns
        elsif last_colmuns != img.columns
          raise ArgumentError.new
        end
        if last_index == 0 then
          last_index = (1364 / img.columns) * img.columns
        end
        if i + last_colmuns > last_index then
          break
        end
        puts parent + item
    
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
        image_count+=1
      rescue
        next
      end
    end
    STICK.write_end
    while !switch_state do
      image_no = (((Time.now.to_f * 1000) / 50) % image_count ).to_i
      g0 = STICK.get_accel().map { |a| a * 8.0 / 0x8000 }
      line = image_no * 16 + g0[1].to_i + 8
      STICK.show_line(line)
    end
    switch_state = false
  end
end

