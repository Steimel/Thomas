require 'thomas'
require_relative 'dangerous'

class DangerousThrower < Thomas::Thing
  def initialize(seconds_per_throw = 1, max_speed=1)
    super([[Thomas::Space.new('')]])
    @elapsed_since_last_throw = 0
    @seconds_per_throw = seconds_per_throw
    @max_speed = max_speed
    @tickable = true
  end

  def handle_tick(seconds_elapsed)
    @elapsed_since_last_throw += seconds_elapsed
    while @elapsed_since_last_throw >= @seconds_per_throw
      throw_dangerous
      @elapsed_since_last_throw -= @seconds_per_throw
    end
  end

  def throw_dangerous
    d = Dangerous.new
    x_v = (2 * rand * @max_speed) - @max_speed
    y_v = (2 * rand * @max_speed) - @max_speed
    edge_rand = rand
    if edge_rand < 0.25
      col = 0
      row = rand * self.canvas.height
      x_v *= -1 if x_v < 0
    elsif edge_rand < 0.5
      col = self.canvas.width-1
      row = rand * self.canvas.height
      x_v *= -1 if x_v > 0
    elsif edge_rand < 0.75
      row = 0
      col = rand * self.canvas.width
      y_v *= -1 if y_v > 0
    else
      row = self.canvas.height-1
      col = rand * self.canvas.width
      y_v *= -1 if y_v < 0
    end
    d.x_velocity = x_v
    d.y_velocity = y_v
    self.canvas.place_thing(d,row,col)
  end
end