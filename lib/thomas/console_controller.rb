module Thomas
  class ConsoleController
    def initialize(metadata=nil)
      @metadata = metadata
      @input_thread = nil
      @stream = nil
    end

    def plug_into(stream)
      @stream = stream
    end

    def unplug
      @stream = nil
    end

    def collect_input
      raise NoStreamError('No input stream given') if @stream.nil?
      @input_thread = Thread.new {
        char = nil
        while char != Thomas::QUIT_CHAR do
          char = Util::read_char_from_stdin
          @stream.put_character(char, @metadata)
        end
      }
    end
  end
end