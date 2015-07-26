module Thomas
  class Util
    def self.build_box(width, height, obj)
      box = []
      height.times do
        r = []
        width.times do
          r.push(obj.dup)
        end
        box.push(r)
      end
      return box
    end

    def self.build_empty_space_box(width, height)
      build_box(width, height, Space.new)
    end

    def self.build_empty_string_box(width, height)
      build_box(width, height, ' ')
    end

    def self.within_bounds?(row, col, width, height)
      !(row < 0 || row >= height || col < 0 || col >= width)
    end

    def self.build_random_canvas(width, height, num_things)
      canvas = Canvas.new(width, height)

      num_things.times do
        r = rand * height
        c = rand * width
        thing_width = (width * rand / 2).ceil
        thing_height = (height * rand / 2).ceil
        canvas.place_thing(build_random_thing(thing_width, thing_height), r, c)
      end

      return canvas
    end

    def self.build_random_thing(width, height, char='X', density=0.5, max_velocity=1)
      box = self.build_empty_space_box(width, height)
      at_least_one = false
      height.times do |r|
        width.times do |c|
          if rand < density
            box[r][c] = Space.new(char)
            at_least_one = true
          end
        end
      end

      unless at_least_one
        row = (rand * height).floor
        col = (rand * width).floor
        box[row][col] = Space.new(char)
      end

      x_v = ((rand * 2 * max_velocity) - max_velocity)
      y_v = ((rand * 2 * max_velocity) - max_velocity)

      return Thing.new(box, {:x_velocity => x_v, :y_velocity => y_v})
    end


    # read a character without pressing enter and without printing to the screen
    def self.read_char_from_stdin
      begin
        # save previous state of stty
        old_state = `stty -g`
        # disable echoing and enable raw (not having to press enter)
        system "stty raw -echo"
        c = STDIN.getc.chr
        # gather next two characters of special keys
        #if(c=="\e")
        #  extra_thread = Thread.new{
        #    c = c + STDIN.getc.chr
        #    c = c + STDIN.getc.chr
        #  }
          # wait just long enough for special keys to get swallowed
        #  extra_thread.join(0.00001)
          # kill thread so not-so-long special keys don't wait on getc
        #  extra_thread.kill
        #end
      rescue => ex
        puts "#{ex.class}: #{ex.message}"
        puts ex.backtrace
      ensure
        # restore previous state of stty
        system "stty #{old_state}"
      end
      return c
    end
  end
end