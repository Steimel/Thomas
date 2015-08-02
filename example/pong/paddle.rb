require 'thomas'

class Paddle < Thomas::Thing

  attr_accessor :score

  def initialize(id, length)
    super(get_paddle(length))
    @drawable = true
    @collidable = true
    @tickable = false
    @inputtable = true
    @id = id
  end

  def handle_input(char, metadata)
    return unless metadata[:id] == @id
    return unless [Thomas::Util::KEY_UP_ARROW,
                   Thomas::Util::KEY_DOWN_ARROW].include?(char)
    row = self.get_row
    col = self.get_col
    width = self.canvas.width
    height = self.canvas.height
    case char
      when Thomas::Util::KEY_UP_ARROW
        row -= 1
      when Thomas::Util::KEY_DOWN_ARROW
        row += 1
    end
    self.set_position(row, col) if Thomas::Util::within_bounds?(row,col,width,height) &&
                                   Thomas::Util::within_bounds?(row+self.height-1,col,width,height)
  end

  def handle_collision(other_thing)
    return unless other_thing.class.to_s == 'Ball'
    other_thing.bounce(self)
  end

  def get_paddle(length)
    paddle = []
    length.times do
      paddle.push([Thomas::Space.new('#')])
    end
    return paddle
  end
end