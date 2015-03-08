module Thomas
  class Textbox < Thing

    def initialize(width, height=1, text='')
      super(Util::build_empty_space_box(width,height))
      @drawable = true
      set_text(text)
    end

    def set_text(text)
      i = 0
      (0...@height).each do |row|
        (0...@width).each do |col|
          @bounding_box[row][col] = Space.new(text[i])
          i += 1
        end
      end
    end
  end
end