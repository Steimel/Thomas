require 'thomas'
require_relative 'ship'
require_relative 'dangerous'
require_relative 'dangerous_thrower'
require_relative 'good'

class Avoidance

  INSTRUCTIONS = 'wasd move, space flash, (q)uit, (r)estart'
  HISCORE_FILE_PATH = File.dirname(__FILE__) + '/hiscore.txt'
  HISCORE_PREFIX = 'Hi-score: '
  SCORE_PREFIX = 'Score: '

  # minimum number of spaces from edge that a good thing must be placed
  EDGE_AVOID = 8

  def initialize(width=81, height=41, seconds_per_throw=1.0/15.0, max_speed=25)
    @thomas = Thomas::Thomas.new(width,height,{:log_file => File.dirname(__FILE__) + '/thomas.log'})
    @instruction_txt = Thomas::Textbox.new(INSTRUCTIONS.length,1,INSTRUCTIONS)
    @hiscore_txt = Thomas::Textbox.new(width - INSTRUCTIONS.length - 2,1,get_highscore_text)
    @ship = Ship.new
    @score_txt = Thomas::Textbox.new(width,1,get_score_text)
    @ship.game = self
    @ship.score_text_box = @score_txt
    @dt = DangerousThrower.new(seconds_per_throw, max_speed)
    @controller = Thomas::ConsoleController.new
    setup_thomas
  end

  def get_highscore_text
    HISCORE_PREFIX + get_highscore.to_s
  end

  def get_score_text
    SCORE_PREFIX + @ship.score.to_s
  end

  def get_highscore
    score = ''
    unless File.exists?(HISCORE_FILE_PATH)
      File.open(HISCORE_FILE_PATH, 'w') do |f|
        f.write('0')
      end
    end
    File.open(HISCORE_FILE_PATH, 'r') do |f|
      score = f.read.to_i
    end
    score
  end

  def setup_thomas
    @thomas.canvas.place_thing(@instruction_txt,0,0)
    @thomas.canvas.place_thing(@hiscore_txt,0,@instruction_txt.width+2)
    @thomas.canvas.place_thing(@ship,@thomas.canvas.height/2,@thomas.canvas.width/2)
    @thomas.canvas.place_thing(@score_txt,@thomas.canvas.height-1,0)
    @thomas.canvas.place_thing(@dt,-1,-1)
    @thomas.add_controller(@controller)
    place_good
  end

  def place_good
    good = Good.new

    # don't place along edge to avoid placing on text
    # plus dangerous things appear randomly on the edge, so it'd be annoying
    done = false
    until done
      row = ((@thomas.canvas.height - (2 * EDGE_AVOID)) * rand) + EDGE_AVOID
      col = ((@thomas.canvas.width - (2 * EDGE_AVOID)) * rand) + EDGE_AVOID
      # also, don't place on the ship
      done = @ship.at_relative_to_canvas(row,col).empty?
    end

    @thomas.canvas.place_thing(good,row,col)
  end

  def update_highscore
    score = @ship.score
    highscore = get_highscore
    if score > highscore
      File.open(HISCORE_FILE_PATH, 'w') do |f|
        f.write(score.to_s)
      end
    end
  end

  def restart
    update_highscore
    @thomas.canvas.things.clear
    @ship.restart
    @hiscore_txt.set_text(get_highscore_text)
    setup_thomas
  end

  def play
    @thomas.start
    sleep(1) until @thomas.killed?
    update_highscore
  end
end

Avoidance.new.play
