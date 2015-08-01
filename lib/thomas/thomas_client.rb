require 'socket'

module Thomas
  class ThomasClient
    def initialize(host, port)
      @input_thread = nil
      @client = nil
      @host = host
      @port = port
      @started = false
      @stream = ThomasStream.new
      @controller = ConsoleController.new.plug_into(@stream)
    end

    def collect_input
      @input_thread = Thread.new {
        char = nil
        while char != Thomas::QUIT_CHAR do
          char = Util::read_char_from_stdin
          @stream.put_character(char, nil)
        end
        @client.close
        @client = nil
      }
    end

    def connect
      @client = TCPSocket.new(@host, @port)
    end

    def send_key(char, metadata)
      @client.puts char
    end

    def full_clear
      system('clear')
    end

    def clear(num_lines)
      print "\r\e[#{num_lines}A"
    end

    def start
      @started = true
      self.connect
      @stream.listen(self, :send_key)
      collect_input
      full_clear
      loop do
        screen = ''
        num_lines = @client.gets.chomp.to_i
        num_lines.times do
          screen += @client.gets
        end
        clear(num_lines)
        STDOUT.write(screen)
      end
    end

  end
end