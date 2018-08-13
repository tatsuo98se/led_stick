from PIL import Image
from stick_sdk import STICK
import btn_handler as btn
from glob import glob
import os
import time

STICK.init_sdk()
STICK.stop_led_demo()
parent = os.path.abspath(\
  os.path.join(\
    os.path.abspath(__file__), '..', '..', 'animations'))

switch_state = False

def myhandler(test):
    print('switch on')
    global switch_state
    switch_state = True

btn_handler = btn.ButtonHandler()
btn_handler.handle_button_down(myhandler)

STICK_MAX_LINE_INDEX = 1364
STICK.write_line(STICK_MAX_LINE_INDEX, [[0,0,0] for _ in range(32)])

g_cache = {}

class CachedImage:
  def __init__(self, filename):
    self.cache = []

    if filename in g_cache:
        self.cache = g_cache[filename]
    else:
        im = Image.open(filename)
        rgb_im = im.convert('RGB')
        size = rgb_im.size
        for x in range(size[0]):
            line = []
            for y in range(size[1]):
                line.append(rgb_im.getpixel((x,y)))
            self.cache.append(line)
    g_cache[filename] = self.cache

  def get_lines(self):
      return self.cache

  def width(self):
      return len(self.cache[0])

  def columns(self):
      return self.width()

  def height(self):
      return len(self.cache)

  def rows(self):
      return self.height()

  def size(self):
      return [self.columns(), self.rows()]
  

while True:
    dirs = glob(os.path.join(parent, '*'))
    dirs.sort()
    for d in dirs:
        if not os.path.basename(d).startswith('anime'):
            continue

        i = 0
        image_count = 0
        last_index = 0
        image_size = [0, 0]

        images = glob(os.path.join(d, '*'))
        images.sort()
        print('loading image..' + str(d))
        for image in images:
            cimg = CachedImage(image)

            if image_size == [0,0]:
                image_size = cimg.size()
            elif image_size != cimg.size():
                raise AttributeError()
            
            if last_index == 0:
                last_index = ((STICK_MAX_LINE_INDEX-1) / cimg.columns()) * cimg.columns()

            if i + cimg.columns() > last_index:
                break

            for line in cimg.get_lines():
                STICK.write_line(i, line)
                i += 1
            image_count += 1
        
        print('complete loading')
        switch_state = False
        while not switch_state:
            image_no = int(((time.time() * 1000) / 50) % image_count )
            g0 = [(a*10.0/0x8000) for a in STICK.get_accel()]

            imageline = 19 - (int(g0[1]) + 10)
            if imageline <= 0 or imageline >= 19:
                STICK.show_line(STICK_MAX_LINE_INDEX)
            else:
                STICK.show_line(image_no * image_size[1] + imageline - 1)


          

