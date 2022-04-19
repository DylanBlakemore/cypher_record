module CypherRecord
  module Dsl
    class Property

      attr_reader :key, :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def make
        "#{key}: #{formatted_value}"
      end

      private

      def formatted_value
        return value.to_s unless value.is_a?(String)
        return "'#{value}'"
      end

    end
  end
end
