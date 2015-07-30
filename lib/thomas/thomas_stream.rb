module Thomas
  class ThomasStream
    def initialize
      @listeners = []
    end

    def listen(listener, method)
      @listeners.push({:listener => listener, :method => method})
    end

    def stop_listening(listener)
      @listeners.reject! do |listener_data|
        listener_data[:listener] == listener
      end
    end

    def put_character(chr, metadata=nil)
      return if chr.nil?
      @listeners.each do |listener_data|
        listener_data[:listener].send(listener_data[:method], chr, metadata)
      end
    end
  end
end