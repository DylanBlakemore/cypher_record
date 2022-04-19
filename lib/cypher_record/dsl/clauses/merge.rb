module CypherRecord
  module Dsl
    class Merge

      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern.is_a?(String) ? Token[pattern] : pattern
      end

      def make
        "MERGE #{pattern.make}"
      end

    end
  end
end
