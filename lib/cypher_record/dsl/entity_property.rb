module CypherRecord
  module Dsl
    class EntityProperty

      attr_reader :property, :entity

      def initialize(property, entity)
        @property = property
        @entity = entity
      end

      def make
        [entity.name, property.key].compact.join(".")
      end

      def eq(other)
        Condition.new(self, :eq, other)
      end

    end
  end
end
