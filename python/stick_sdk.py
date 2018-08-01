import os
from ctypes import *
import sys
import platform
#import util.logger as logger
from PIL import Image
from datetime import datetime


dirname = os.path.dirname(__file__)
dirname = os.path.abspath(os.path.join(dirname, '..'))
lib = dirname + '/lib/stick_sdk.so' 

#logger.i('LoadLibrary: '+ str(ledlib))

class LedStick(object):
    def __init__(self, stick):
        self.stick = stick

    def init_sdk(self):
        self.stick.init_sdk()

    def stop_led_demo(self):
        self.stick.stop_led_demo()

    def write_line(self, line, pattern):
        carray = c_byte * len(pattern) 
        cpattern = carray(*pattern) 
        self.stick.write_line(line, cpattern)

    def show_line(self, line):
        self.stick.show_line(line)

    def get_accel(self):
        carray = c_short * 3
        s_arr = [0 for i in range(3)]  
        a = carray(*s_arr)  
        self.stick.get_accel(a)
        print(str(a))
        return a

    def get_gyro(self):
        carray = c_short * 3
        s_arr = [0 for i in range(3)]  
        g = carray(*s_arr)  
        self.stick.get_gyro(g)
        print(str(g))
        return g

class LedStickDummy(object):
    def __init__(self):
        pass

    def init_sdk(self):
        pass

    def stop_led_demo(self):
        pass

    def write_line(self, line, pattern):
        pass

    def show_line(self, line):
        pass

    def get_accel(self, a):
        pass

    def get_gyro(self, g):
        pass



def create_led_stick(lib):
    try:
        return LedStick(cdll.LoadLibrary(lib))
    except OSError:
        return LedStickDummy()

STICK = create_led_stick(lib)
