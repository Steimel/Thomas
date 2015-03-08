module Thomas
  class Canvas
    attr_reader :width, :height, :things

    def initialize(width, height)
      @width = width
      @height = height
      @things = []
    end

    def drawable_things
      @things.select{|thing| thing.drawable}
    end

    def place_thing(thing, r, c)
      thing.set_position(r,c)
      thing.canvas = self
      @things.push(thing)
    end

    def draw(border=false)
      self.to_s(border)
    end

    def to_s(border=false)
      output = Util.build_empty_string_box(@width, @height)
      drawable_things.each do |thing|
        output = thing.draw(output, @width, @height)
      end
      if border
        top_bottom_bar = ('-' * (@width + 2))
        return top_bottom_bar + "\n\r" + output.map{|row| '|' + row.join('') + '|'}.join("\n\r") + "\n\r" + top_bottom_bar
      else
        return output.map{|row| row.join('')}.join("\n\r")
      end
    end

  end
end