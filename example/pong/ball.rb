require 'thomas'

class Ball < Thomas::Thing

  def initialize(game, max_speed=20)
    super([[Thomas::Space.new('@')]])
    @drawable = true
    @collidable = true
    @tickable = true
    @game = game
    @max_speed = max_speed
  end

  def handle_collision(other_thing)
    return unless other_thing.class.to_s == 'Paddle'
    bounce(other_thing)
  end

  def bounce(paddle)
    self.x_velocity *= -1
    #TODO: change y velocity depending on where on the paddle the ball hit
  end

  def handle_tick(seconds_elapsed)
    super(seconds_elapsed)
    if wall_bounce?
      do_wall_bounce
    end
    if scored?
      if self.get_col < 0
        @game.player2_score
        init_player2
      else
        @game.player1_score
        init_player1
      end
    end
  end

  def init
    self.row = self.canvas.height / 2
    self.col = self.canvas.width / 2
    self.y_velocity = rand * @max_speed
    self.y_velocity *= -1 if [true, false].sample
    self.x_velocity = @max_speed
  end

  def init_player1
    init
  end

  def init_player2
    init
    self.x_velocity *= -1
  end

  def do_wall_bounce
    self.y_velocity = -1 * self.y_velocity
  end

  def wall_bounce?
    !Thomas::Util::within_bounds?(self.get_row,0,self.canvas.width,self.canvas.height)
  end

  def scored?
    !Thomas::Util::within_bounds?(0,self.get_col,self.canvas.width,self.canvas.height)
  end


end