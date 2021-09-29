module CypherRecord
  module Adapters
    class Neo4jAdapter < CypherRecord::EntityAdapter

      def self.adapt(result)
        [result.keys, result.values].transpose.map do |key, record|
          adapt_single(key, record)
        end
      end

      private

      def self.adapt_single(key, record)
        case record
        when Neo4j::Driver::Types::Node
          adapt_entity(key, record, record.labels.first)
        when Neo4j::Driver::Types::Relationship
          adapt_entity(key, record, record.type)
        else
          record
        end
      end

      def self.adapt_entity(key, record, label)
        if entity_class = resolve_label(label).safe_constantize
          entity_class.new(variable_name: key, **record.properties)
        else
          raise(CypherRecord::LabelError, "Model for label #{label} does not exist")
        end
      end

    end
  end
end
