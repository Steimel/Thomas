require 'thomas'
require_relative 'ship'

class Good < Thomas::Thing
  def initialize
    super([[Thomas::Space.new('Y')]])
    @drawable = true
    @collidable = true
  end

  def handle_collision(other_thing)
    return unless other_thing.class.to_s == 'Ship'
    other_thing.collect(self)
  end

end