require_relative './btn_handler'

handler = ButtonHandler.new

begin
  handler.handle_button_down {
    puts('pushed')
  }
  handler.join()
ensure
  handler.stop()
end
