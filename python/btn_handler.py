import RPi.GPIO as GPIO
import time

PIN = 17

class ButtonHandler:
    def __init__(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(PIN,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)

    def handle_button_down(self, callback):
        GPIO.add_event_detect(PIN, GPIO.FALLING, bouncetime=50)
        GPIO.add_event_callback(PIN, callback)

