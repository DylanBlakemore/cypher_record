module CypherRecord
  module QueryMethods
    module Filtering

      include CypherRecord::QueryMethods::Base

      def limit(n)
        append_value("LIMIT", n)
      end
  
      def where(entity=nil, **properties)
        append("WHERE", entity) do |entity|
          properties.map do |key, value|
            CypherRecord::Format.property_assignment(entity.variable_name, key, value)
          end.join(" AND ")
        end
      end
  
      def match(entity=nil)
        append_entity("MATCH", entity)
      end

      def return(entity=nil, properties: nil)
        return append_properties("RETURN", entity, properties) if properties
        append_variable("RETURN", entity)
      end

    end
  end
end
