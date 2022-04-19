module CypherRecord
  module Dsl
    class Create

      attr_reader :pattern

      def initialize(pattern)
        @pattern = pattern.is_a?(String) ? Token[pattern] : pattern
      end

      def make
        "CREATE #{pattern.make}"
      end

    end
  end
end
