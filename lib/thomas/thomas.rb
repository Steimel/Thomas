module Thomas
  class Thomas
    QUIT_CHAR = 'q'

    attr_accessor :canvas, :output_buffer

    def initialize(width, height, options={})
      @canvas = Canvas.new(width, height)
      @output_buffer = options.key?(:output_buffer) ? options[:output_buffer] : STDOUT
      @refresh_period = options.key?(:refresh_period) ? options[:refresh_period] : 1.0/20.0
    end

    def full_clear
      system('clear') if @output_buffer == STDOUT
    end

    def clear
      print "\r\e[#{@canvas.height+1}A"
    end

    def draw
      @output_buffer.write(@canvas.draw(true))
    end

    def things
      @canvas.things
    end

    def tickable_things
      things.select{|thing| thing.tickable}
    end

    def collidable_things
      things.select{|thing| thing.collidable}
    end

    def inputtable_things
      things.select{|thing| thing.inputtable}
    end

    def drawable_things
      things.select{|thing| thing.drawable}
    end

    def tick
      tickable_things.each{|thing| thing.handle_tick(@refresh_period)}
      collisions = []

      (0...collidable_things.size).each do |i|
        obj_i = collidable_things[i]
        ((i+1)...collidable_things.size).each do |j|
          obj_j = collidable_things[j]
          collisions.push([obj_i, obj_j]) if obj_i.collision?(obj_j)
        end
      end

      collisions.each do |collision|
        collision[0].handle_collision(collision[1])
      end
    end

    def start
      full_clear
      refresh_thread = Thread.new {
        while true do
          clear
          draw
          sleep(@refresh_period)
          tick
        end
      }
      char = nil
      until char == QUIT_CHAR
        char = Util::read_char
        inputtable_things.each do |thing|
          thing.handle_input(char)
        end
      end
      refresh_thread.kill
    end

  end
end