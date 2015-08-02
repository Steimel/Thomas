require 'thomas'

class PongClient
  def initialize(host='localhost', port=22992)
    @thomas_client = Thomas::ThomasClient.new(host, port)
  end

  def play
    @thomas_client.start
  end
end

PongClient.new.play