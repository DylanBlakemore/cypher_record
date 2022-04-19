module CypherRecord
  module Dsl
    class Match

      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern.is_a?(String) ? Token[pattern] : pattern
      end

      def make
        "MATCH #{pattern.make}"
      end

    end
  end
end
