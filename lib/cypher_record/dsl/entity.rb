module CypherRecord
  module Dsl
    class Entity

      attr_reader :labels, :name, :properties

      def initialize(*labels, name: nil, properties: nil)
        @labels = labels
        @name = name
        @properties = properties.is_a?(Hash) ? PropertySet.from_hash(properties) : properties
      end

      def named(name)
        self.class.new(*labels, name: name, properties: properties)
      end

      def with_properties(properties)
        self.class.new(*labels, name: name, properties: properties)
      end

      def make
        raise NotImplementedError, "#{self.class} must implement 'make'"
      end

      def property(prop)
        EntityProperty.new(properties.get(prop), self)
      end

      protected

      def formatted_data
        [
          [name, formatted_labels].compact.join.presence,
          properties&.make
        ].compact.join(" ")
      end

      def formatted_labels
        labels.map { |label| ":#{label}" }.join
      end

    end
  end
end
