require './bcm2835'
class ButtonHandler

  def initializer
    if BCM.bcm2835_init.zero?
      puts 'failed to init bcm2835'
        exit 1
    end
    
    GPIO = 17
    BCM.bcm2835_gpio_fsel(GPIO, 0)
    BCM.bcm2835_gpio_set_pud(GPIO, 1)
    @stop = false
    @t = nil
  end

  def handle_button_down
    @last_state = 0
    @t = Thread.new{
      while !@stop { 
        current_state = BCM.bcm2835_gpio_lev(GPIO)
        if @last_state != current_state && current_state == 1{
          yield
        }
        sleep(0.3)
      }
    }
  end

  def stop
    @stop = true
    @t.join
  end

  def join
    @t.join
  end
end