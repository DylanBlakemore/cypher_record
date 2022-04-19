module CypherRecord
  module Dsl
    class Token

      attr_reader :value

      def self.[](value)
        self.new(value)
      end

      def initialize(value)
        @value = value
      end

      def make
        value.to_s
      end

    end
  end
end
