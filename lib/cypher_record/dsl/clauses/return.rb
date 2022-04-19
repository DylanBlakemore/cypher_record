module CypherRecord
  module Dsl
    class Return

      attr_reader :return_values

      def initialize(*return_values)
        @return_values = return_values
      end

      def make
        "RETURN #{return_strings.join(", ")}"
      end

      private

      def return_strings
        return_values.map do |value|
          case value
          when String
            value
          when Node, Relationship
            value.name
          when EntityProperty
            value.make
          else
            raise ArgumentError, "Return value #{value} is not a supported type"
          end
        end
      end

    end
  end
end
