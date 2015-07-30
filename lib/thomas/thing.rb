module Thomas
  class Thing
    attr_accessor :row, :col, :x_velocity, :y_velocity, :canvas, :tickable, :collidable, :inputtable, :drawable, :bounding_box
    attr_reader :width, :height

    def initialize(bounding_box, options={})
      @width = bounding_box[0].size
      @height = bounding_box.size
      @bounding_box = bounding_box
      @x_velocity = options.key?(:x_velocity) ? options[:x_velocity] : 0
      @y_velocity = options.key?(:y_velocity) ? options[:y_velocity] : 0
      @tickable = options.key?(:tickable) ? options[:tickable] : false
      @collidable = options.key?(:collidable) ? options[:collidable] : false
      @inputtable = options.key?(:inputtable) ? options[:inputtable] : false
      @drawable = options.key?(:drawable) ? options[:drawable] : false
      @row = 0
      @col = 0
    end

    def collision?(other_thing)
      min_row = [get_row, other_thing.get_row].max
      max_row = [get_row + @height - 1, other_thing.get_row + other_thing.height - 1].min

      min_col = [get_col, other_thing.get_col].max
      max_col = [get_col + @width - 1, other_thing.get_col + other_thing.width - 1].min

      return false if min_row > max_row || min_col > max_col

      (min_row..max_row).each do |row|
        (min_col..max_col).each do |col|
          return true if self.at_relative_to_canvas(row, col).occupied? && other_thing.at_relative_to_canvas(row, col).occupied?
        end
      end

      return false
    end

    def handle_collision(other_thing)
      # noop for generic thing
    end

    def handle_input(char, metadata)
      # noop for generic thing
    end

    def handle_tick(seconds_elapsed)
      move(@y_velocity*seconds_elapsed, @x_velocity*seconds_elapsed)
    end

    def get_row
      @row.round
    end

    def get_col
      @col.round
    end

    def set_position(r,c)
      @row = r
      @col = c
    end

    def move(rows,cols)
      @row += rows
      @col += cols
    end

    def at(r,c)
      return @bounding_box[r][c] if Util::within_bounds?(r, c, @width, @height)
      Space.new
    end

    def at_relative_to_canvas(r,c)
      rel_r = r - get_row
      rel_c = c - get_col
      return self.at(rel_r, rel_c)
    end

    def draw(box, box_width, box_height)
      @height.times do |r|
        @width.times do |c|
          box[r+get_row][c+get_col] = self.at(r,c).to_s if Util::within_bounds?(r+get_row,c+get_col,box_width,box_height)
        end
      end
      return box
    end

  end
end