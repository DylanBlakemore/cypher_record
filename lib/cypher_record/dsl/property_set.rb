module CypherRecord
  module Dsl
    class PropertySet

      def self.from_hash(hash)
        self.new(
          hash.map { |k, v| Property.new(k, v) }
        )
      end

      attr_reader :properties

      def initialize(properties)
        @properties = properties
      end

      def make
        "{#{properties.map(&:make).join(", ")}}"
      end

      def [](key)
        indexed_properties[key].value
      end

      def get(key)
        indexed_properties[key]
      end

      private

      def indexed_properties
        @indexed_properties ||= properties.each_with_object({}) do |property, index|
          index[property.key] = property
        end
      end

    end
  end
end
