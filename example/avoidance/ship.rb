require 'thomas'

class Ship < Thomas::Thing

  attr_accessor :game, :alive, :score, :score_text_box

  DIRECTION_UP = [-1,0]
  DIRECTION_DOWN = [1,0]
  DIRECTION_LEFT = [0,-1]
  DIRECTION_RIGHT = [0,1]

  SPACE_SPEED = 3

  def initialize
    @direction_cache = {}
    bb = get_ship_direction(DIRECTION_UP)
    super(bb)
    @alive = true
    @drawable = true
    @collidable = true
    @tickable = false
    @inputtable = true
    @score = 0
  end

  def handle_input(char)
    dchar = char.downcase
    return @game.restart if dchar == 'r'
    return unless @alive
    return unless ['w','a','s','d',' '].include?(dchar)
    row = self.get_row
    col = self.get_col
    width = self.canvas.width
    height = self.canvas.height
    case dchar
      when 'w'
        row -= 1
        set_ship_direction(DIRECTION_UP)
      when 's'
        row += 1
        set_ship_direction(DIRECTION_DOWN)
      when 'a'
        col -= 1
        set_ship_direction(DIRECTION_LEFT)
      when 'd'
        col += 1
        set_ship_direction(DIRECTION_RIGHT)
      when ' '
        row += @direction[0] * SPACE_SPEED
        col += @direction[1] * SPACE_SPEED
    end
    self.set_position(row, col) if Thomas::Util::within_bounds?(row,col,width,height)
  end

  def handle_collision(other_thing)
    case other_thing.class.to_s
      when 'Dangerous'
        self.hit
      when 'Good'
        self.collect(other_thing)
    end
  end

  def hit
    @bounding_box[1][1] = Thomas::Space.new('#')
    @collidable = false
    @tickable = false
    @alive = false
  end

  def collect(good)
    @score += 1
    @score_text_box.set_text(@game.get_score_text)
    good.drawable = false
    good.collidable = false
    @game.place_good
  end

  def restart
    @score = 0
    @score_text_box.set_text(@game.get_score_text)
    @alive = true
    @collidable = true
    @tickable = true
    @bounding_box[1][1] = Thomas::Space.new(nil)
  end

  def set_ship_direction(direction)
    @direction = direction
    @bounding_box = get_ship_direction(direction)
  end

  def get_ship_direction(direction)
    case direction
      when DIRECTION_UP
        return @direction_cache[DIRECTION_UP] if @direction_cache.key?(DIRECTION_UP)
        ship = [
            [Thomas::Space.new(nil), Thomas::Space.new('X'), Thomas::Space.new(nil)],
            [Thomas::Space.new('X'), Thomas::Space.new(nil), Thomas::Space.new('X')],
            [Thomas::Space.new('X'), Thomas::Space.new('X'), Thomas::Space.new('X')]
        ]
        @direction_cache[DIRECTION_UP] = ship
      when DIRECTION_DOWN
        return @direction_cache[DIRECTION_DOWN] if @direction_cache.key?(DIRECTION_DOWN)
        ship = [
            [Thomas::Space.new('X'), Thomas::Space.new('X'), Thomas::Space.new('X')],
            [Thomas::Space.new('X'), Thomas::Space.new(nil), Thomas::Space.new('X')],
            [Thomas::Space.new(nil), Thomas::Space.new('X'), Thomas::Space.new(nil)]
        ]
        @direction_cache[DIRECTION_DOWN] = ship
      when DIRECTION_LEFT
        return @direction_cache[DIRECTION_LEFT] if @direction_cache.key?(DIRECTION_LEFT)
        ship = [
            [Thomas::Space.new(nil), Thomas::Space.new('X'), Thomas::Space.new('X')],
            [Thomas::Space.new('X'), Thomas::Space.new(nil), Thomas::Space.new('X')],
            [Thomas::Space.new(nil), Thomas::Space.new('X'), Thomas::Space.new('X')]
        ]
        @direction_cache[DIRECTION_LEFT] = ship
      when DIRECTION_RIGHT
        return @direction_cache[DIRECTION_RIGHT] if @direction_cache.key?(DIRECTION_RIGHT)
        ship = [
            [Thomas::Space.new('X'), Thomas::Space.new('X'), Thomas::Space.new(nil)],
            [Thomas::Space.new('X'), Thomas::Space.new(nil), Thomas::Space.new('X')],
            [Thomas::Space.new('X'), Thomas::Space.new('X'), Thomas::Space.new(nil)]
        ]
        @direction_cache[DIRECTION_RIGHT] = ship
    end
    return ship
  end
end