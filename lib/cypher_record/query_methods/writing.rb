module CypherRecord
  module QueryMethods
    module Writing

      include CypherRecord::QueryMethods::Base

      def merge(entity=nil)
        append_entity("MERGE", entity)
      end

      def create(entity=nil)
        append_entity("CREATE", entity)
      end

      def delete(entity=nil)
        append_variable("DELETE", entity)
      end

      def destroy(entity=nil)
        append_variable("DETACH DELETE", entity)
      end

      def set(property, value, entity=nil)
        append("SET", entity) do |entity|
          CypherRecord::Format.property_assignment(entity.variable_name, property, value)
        end
      end

    end
  end
end
