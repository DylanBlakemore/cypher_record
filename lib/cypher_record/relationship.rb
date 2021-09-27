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
      "#{node_string(left)} #{left_arrow} #{edge.to_s} #{right_arrow} #{node_string(right)}"
    end

    def edge_only
      CypherRecord::Relationship.new("(#{left.id})", edge, "(#{right.id})", direction)
    end

    private

    def node_string(node)
      node&.to_s || "()"
    end

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
