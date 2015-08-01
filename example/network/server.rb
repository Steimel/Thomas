require 'thomas'

class ControlOutputter < Thomas::Thing

  def initialize(tb, id)
    super([[Thomas::Space.new('')]])
    @inputtable = true
    @text = tb
    @id = id
  end

  def handle_input(char, metadata)
    @text.set_text(char) if metadata[:id] == @id
  end

end

class TestServer

  def initialize(width=20, height=20, port=22992)
    @thomas = Thomas::Thomas.new(width,height)
    @txtLocal = Thomas::Textbox.new(10,1,'')
    @txtNetwork = Thomas::Textbox.new(10,1,'')
    @coLocal = ControlOutputter.new(@txtLocal, 'local')
    @coNetwork = ControlOutputter.new(@txtNetwork, 'network')
    @console_controller = Thomas::ConsoleController.new({:id => 'local'})
    @network_controller = Thomas::NetworkController.new(port, {:id => 'network'})
    setup_thomas
  end

  def setup_thomas
    @thomas.canvas.place_thing(@txtLocal,0,0)
    @thomas.canvas.place_thing(@txtNetwork,5,0)

    @thomas.canvas.place_thing(@coLocal,-1,-1)
    @thomas.canvas.place_thing(@coNetwork,-1,-1)

    @thomas.add_controller(@console_controller)
    @thomas.add_controller(@network_controller)
  end


  def play
    @thomas.start
    sleep(1) until @thomas.killed?
  end
end

TestServer.new.play
