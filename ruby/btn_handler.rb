require_relative './bcm2835'
class ButtonHandler

  def initializer
    @stop = false
    @t = nil
  end

  def handle_button_down
    @last_state = 0
    @t = Thread.new{
      if BCM.bcm2835_init.zero?
        puts 'failed to init bcm2835'
          exit 1
      end
      BCM.bcm2835_gpio_fsel(17, 0)
      BCM.bcm2835_gpio_set_pud(17, 1)
    
      while !@stop do
        current_state = BCM.bcm2835_gpio_lev(17)
        if @last_state != current_state && current_state == 1 then
          yield
	end
	@last_state = current_state
        sleep(0.3)
      end
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
