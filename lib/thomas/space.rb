module Thomas
  class Space
    attr_accessor :occupant

    def initialize(occupant = nil)
      @occupant = occupant
    end

    def empty?
      @occupant.nil?
    end

    def occupied?
      !self.empty?
    end

    def to_s
      @occupant.nil? ? ' ' : @occupant.to_s
    end
  end
end