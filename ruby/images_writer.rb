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

STICK_MAX_LINE_INDEX=1364
STICK.write_line(STICK_MAX_LINE_INDEX, [0]*96)


class CachedImage
  def initialize(filename)
    @basedir = File.join("./.cache/", File.basename(File.expand_path("..", filename)))
    @baseanme = File.basename(filename, '.png')
    @image = nil
    @cache = []
    @cache_filename = File.join(@basedir,  @baseanme + '.txt')

    if File.exist? @cache_filename then
      # use cache
      File.open(@cache_filename) do |f|
        loop do
          begin
            a = f.readline.strip
            a = a.split ','
            @cache << a.map {|e| e.to_i}
          rescue EOFError
            break
          end
        end
      end
    else
      @image = ImageList.new(filename).first
      @image.columns.times do |x|
        line = []
        img_line = @image.get_pixels(x, 0, 1, @image.rows)
        img_line.each_with_index do |p, y|
          p  = @image.pixel_color(x, y)
          line << p.red << p.green << p.blue
        end
        @cache << line
      end

      unless File.exist? @basedir then
        Dir.mkdir @basedir
      end
      File.open(@cache_filename, 'w') do |f|
        @cache.each do |line|
          line.each do |e|
            f.write e
            f.write ','
          end
          f.write "\n"
        end
      end
    end
  end

  def cache?
    File.exist? @cache_filename
  end

  def width
    @cache[0].length
  end

  def columns
    return self.width
  end

  def height
    @cache.length
  end

  def rows
    return self.height
  end

  def eachline
    @cache.each do |line|
      yield line
    end
  end
end

loop do
  Dir.foreach(parent).sort.each do |childdir|
    next unless childdir.start_with? 'anime' 
    
    i = 0
    image_count = 0
    last_index = 0
    last_colmuns = 0

    Dir.foreach(File.join(parent, childdir)).sort.each do |item|
      start = (Time.now.to_f * 1000) ##
      begin
        img = CachedImage.new(File.join(parent, childdir, item))
        if last_colmuns == 0 then
          last_colmuns = img.columns
        elsif last_colmuns != img.columns
          raise ArgumentError.new
        end
        if last_index == 0 then
          last_index = ((STICK_MAX_LINE_INDEX-1) / img.columns) * img.columns
        end
        if i + last_colmuns > last_index then
          break
        end
        puts parent + item
    
        img.eachline do |line|
          STICK.write_line(i, line)
          i+=1
        end
        image_count+=1
        span = (Time.now.to_f * 1000) - start ##
        puts "childdir:#{span.to_s}" #, cache:#{img.cache?}"
      rescue Magick::ImageMagickError
        next
      rescue => e
        p e
        raise e
      end
    end
    STICK.write_end
    while !switch_state do
      image_no = (((Time.now.to_f * 1000) / 50) % image_count ).to_i
      g0 = STICK.get_accel().map { |a| a * 10.0 / 0x8000 }
      imageline = 19 - (g0[1].to_i + 10)
      if imageline <= 0 || imageline >= 19 then
        STICK.show_line(STICK_MAX_LINE_INDEX)
      else
        STICK.show_line(image_no * last_colmuns + imageline - 1)
      end
    end
    switch_state = false
  end
end

