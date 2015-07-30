module Thomas
  class Thomas
    QUIT_CHAR = 'q'
    PAUSE_CHAR = 'p'

    attr_accessor :canvas, :output_buffer, :log_file

    def initialize(width, height, options={})
      @canvas = Canvas.new(width, height)
      @input_stream = ThomasStream.new
      @output_buffer = options.key?(:output_buffer) ? options[:output_buffer] : STDOUT
      @refresh_period = options.key?(:refresh_period) ? options[:refresh_period] : 1.0/20.0
      @log_file = options.key?(:log_file) ? options[:log_file] : nil
      @started = false
      @paused = false
      @killed = false
      @controllers = []
    end

    def add_controller(controller)
      @controllers.push(controller)
      controller.plug_into(@input_stream)
    end

    def remove_controller(controller)
      removed = @controllers.delete(controller)
      removed.unplug unless removed.nil?
    end

    def killed?
      @killed
    end

    def paused?
      @paused
    end

    def started?
      @started
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


    def log(message)
      unless @log_file.nil?
        File.open(@log_file, 'a') do |f|
          f.write(Time.now.to_s + ': ' + message + "\n")
        end
      end
    end

    def start
      log('Starting Thomas')
      @started = true
      start_refresh_thread
      start_listening_for_input
    end

    def start_refresh_thread
      full_clear
      @refresh_thread = Thread.new {
        while true do
          clear
          draw
          sleep(@refresh_period)
          tick
        end
      }
    end

    def stop_refresh_thread
      @refresh_thread.kill
    end

    def start_listening_for_input
      @input_stream.listen(self, :handle_input)
      @controllers.each(&:collect_input)
    end

    def stop_listening_for_input
      @input_stream.stop_listening(self)
    end

    def handle_input(char, metadata)
      return if @killed || !@started

      unless @paused
        inputtable_things.each do |thing|
          thing.handle_input(char, metadata)
        end
      end

      case char
        when PAUSE_CHAR
          if @paused
            log('Unpausing')
            @paused = false
            start_refresh_thread
          else
            log('Pausing')
            @paused = true
            stop_refresh_thread
          end
        when QUIT_CHAR
          @killed = true
          log('Stopping Thomas')
          stop_refresh_thread
          stop_listening_for_input
      end
    end

  end
end