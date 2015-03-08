require 'thomas'
require_relative 'ship'

class Dangerous < Thomas::Thing
  def initialize
    super([[Thomas::Space.new('@')]])
    @drawable = true
    @collidable = true
    @tickable = true
  end

  def handle_collision(other_thing)
    return unless other_thing.class.to_s == 'Ship'
    other_thing.hit
  end

  def handle_tick(seconds_elapsed)
    super(seconds_elapsed)
    unless Thomas::Util::within_bounds?(self.get_row,self.get_col,self.canvas.width,self.canvas.height)
      @drawable = false
      @collidable = false
      @tickable = false
    end
  end


end