module CypherRecord
  module QueryMethods
    module Base

      def base_entity
        nil
      end

      protected

      def append_value(operator, value)
        append_to_query(operator, CypherRecord::Format.property(value))
      end

      def append(operator, entity, &block)
        appended_value = yield (focus_entity(entity))
        append_to_query(operator, appended_value)
      end

      def append_properties(operator, entity, properties)
        append_to_query(
          operator,
          CypherRecord::Format.property_keys(focus_entity(entity).variable_name, properties)
        )
      end

      def append_variable(operator, entity)
        append_to_query(operator, focus_entity(entity).variable_name)
      end

      def append_entity(operator, entity)
        append_to_query(operator, focus_entity(entity).realize)
      end

      def append_to_query(operator, value)
        CypherRecord::Query.new(
          query: query.append(CypherRecord::Token.new(operator, value)),
          entity: base_entity
        )
      end

      def focus_entity(entity)
        entity || base_entity
      end

    end
  end
end
