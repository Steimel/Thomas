require 'socket'

module Thomas
  class NetworkController
    def initialize(port, metadata=nil)
      @metadata = metadata
      @input_thread = nil
      @stream = nil
      @server = nil
      @client = nil
      @port = port
    end

    def plug_into(stream)
      @stream = stream
    end

    def unplug
      @stream = nil
    end

    def collect_input
      raise NoStreamError('No input stream given') if @stream.nil?
      @server = TCPServer.new(@port)
      puts 'Waiting for connection on port ' + @port.to_s
      @client = @server.accept
      @input_thread = Thread.new {
        char = nil
        while char != Thomas::QUIT_CHAR do
          char = @client.gets.chomp
          @stream.put_character(char, @metadata)
        end
        @client.close
        @server.close
        @client = nil
        @server = nil
      }
    end

    def refresh_remote_screen(screen)
      return if @client.nil?
      @client.puts(screen.split("\n").size)
      @client.puts(screen)
    end

  end
end