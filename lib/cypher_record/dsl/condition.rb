module CypherRecord
  module Dsl
    class Condition

      attr_reader :left, :operator, :right

      def initialize(left, operator, right)
        @left = left.is_a?(String) ? Token[left] : left
        @operator = operator
        @right = right.is_a?(String) ? Token[right] : right
      end

    end
  end
end
