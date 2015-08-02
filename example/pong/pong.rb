require 'thomas'
require_relative 'paddle'
require_relative 'ball'

class Pong

  INSTRUCTIONS = 'arrow keys to move, (q)uit, (r)estart'
  SCORE_PREFIX = 'Score: '
  PADDLE_LENGTH = 5

  def initialize(width=80, height=40, port=22992)
    @thomas = Thomas::Thomas.new(width,height,{:log_file => File.dirname(__FILE__) + '/thomas.log'})
    @instruction_txt = Thomas::Textbox.new(INSTRUCTIONS.length,1,INSTRUCTIONS)
    @pdlPlayer1 = Paddle.new(1, PADDLE_LENGTH)
    @pdlPlayer2 = Paddle.new(2, PADDLE_LENGTH)
    @score1 = 0
    @score2 = 0
    @score_txt1 = Thomas::Textbox.new(width/2,1,get_score_text(1))
    @score_txt2 = Thomas::Textbox.new(width/2,1,get_score_text(2))
    @ball = Ball.new(self)
    @player1Controller = Thomas::ConsoleController.new({id: 1})
    @player2Controller = Thomas::NetworkController.new(port, {id: 2})
    setup_thomas
  end

  def get_score_text(player)
    score = (player == 1 ? @score1 : @score2).to_s
    SCORE_PREFIX + score
  end

  def player1_score
    @score1 += 1
    @score_txt1.set_text(get_score_text(1))
  end

  def player2_score
    @score2 += 1
    @score_txt2.set_text(get_score_text(2))
  end

  def setup_thomas
    @thomas.canvas.place_thing(@instruction_txt,0,0)
    @thomas.canvas.place_thing(@score_txt1,@thomas.canvas.height-1,0)
    @thomas.canvas.place_thing(@score_txt2,@thomas.canvas.height-1,@thomas.canvas.width/2)


    @thomas.canvas.place_thing(@ball,0,0)
    @ball.init_player1

    @thomas.canvas.place_thing(@pdlPlayer1,@thomas.canvas.height/2,0)
    @thomas.canvas.place_thing(@pdlPlayer2,@thomas.canvas.height/2,@thomas.canvas.width-1)


    @thomas.add_controller(@player1Controller)
    @thomas.add_controller(@player2Controller)
  end

  def play
    @thomas.start
    sleep(1) until @thomas.killed?
  end
end

Pong.new.play
