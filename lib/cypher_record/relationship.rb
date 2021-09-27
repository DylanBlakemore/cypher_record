module CypherRecord
  class Relationship

    attr_reader :left, :edge, :right, :direction

    def initialize(left, edge, right, direction=:mutual)
      raise(ArgumentError, "Relationship direction can only be forwards, backwards, or mutual") unless [:mutual, :backwards, :forwards].include?(direction)
      @left = left
      @edge = edge
      @right = right
      @direction = direction
    end

    def to_s
      "#{left.to_s} #{left_arrow} #{edge.to_s} #{right_arrow} #{right.to_s}"
    end

    private

    LEFT_POINTER = "<-"
    RIGHT_POINTER = "->"
    MUTUAL_POINTER = "-"

    def left_arrow
      case direction
      when :mutual
        MUTUAL_POINTER
      when :forwards
        MUTUAL_POINTER
      when :backwards
        LEFT_POINTER
      end
    end

    def right_arrow
      case direction
      when :mutual
        MUTUAL_POINTER
      when :forwards
        RIGHT_POINTER
      when :backwards
        MUTUAL_POINTER
      end
    end

  end
end
