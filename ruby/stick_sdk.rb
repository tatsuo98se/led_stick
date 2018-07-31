# frozen_string_literal: true

require 'fiddle/import'
require 'RMagick'
include Magick

load_error = false
begin
  module INTERNAL_STICK_SDK
    extend Fiddle::Importer
    dlload '../lib/stick_sdk.so'
    extern 'int init_sdk(void)'
    extern 'void stop_led_demo(void)'
    extern 'void write_line(int line, char * pattern)'
    extern 'void show_line(int line)'
    extern 'void get_accel(short *)'
    extern 'void get_gyro(short *)'
  end
rescue
  load_error = true
end

class IStickSdk
  def initialize()
    @lines = {}
    @pattern_height = 0
  end
  def init_sdk()
    puts "init_sdk()"
  end
  def stop_led_demo()
    puts "stop_led_demo()"
  end
  def write_line(line, pattern)
    @lines[line] = pattern.map {|p| p/(85.0*256)}
    @pattern_height = pattern.length / 3
    puts "write_line(#{line}, #{pattern})"


  end
  def write_end()
    f = Image.new([1364, [0, @lines.length].max].min, @pattern_height)
    @lines.each do |x, vline|
      y = 0
      vline.each_slice(3) do |r, g, b|
        px = Pixel.new(*([r,g,b].map{|p|(p*85*256)}))
        f.pixel_color(x, y, px)
        y += 1
      end
    end
    f.write('./image.png')

  end
  def show_line(line)
    puts "show_line(#{line})"
  end
  def get_accel()
    puts "get_accel()"
  end
  def get_gyro()
    puts "get_gyro()"
  end
end

class StickSdk
  def init_sdk()
    INTERNAL_STICK_SDK.init_sdk()
  end
  def stop_led_demo()
    INTERNAL_STICK_SDK.stop_led_demo()
  end
  def write_line(line, pattern)
    INTERNAL_STICK_SDK.write_line(line, pattern.pack('C*'))
  end
  def write_end()
  end
  def show_line(line)
    INTERNAL_STICK_SDK.show_line(line)
  end
  def get_accel()
    a = ([0] * 6).pack('C*')
    INTERNAL_STICK_SDK.get_accel(a)
    return a.unpack('s*')
  end
  def get_gyro()
    g = ([0] * 6).pack('C*')
    INTERNAL_STICK_SDK.get_gyro(g)
    return g.unpack('s*')
  end
end

STICK =  IStickSdk.new

if load_error || INTERNAL_STICK_SDK.init_sdk.zero?
  puts 'failed to init SDK. return dummy IF.'
  return
end


STICK = StickSdk.new