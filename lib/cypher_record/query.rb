module CypherRecord
  class Query

    attr_reader :query, :base_entity

    def initialize(query: [], entity: nil)
      @query = query
      @base_entity = entity
    end

    def merge(entity=nil)
      append_entity("MERGE", entity)
    end

    def create(entity=nil)
      append_entity("CREATE", entity)
    end

    def match(entity=nil)
      append_entity("MATCH", entity)
    end

    def return(entity=nil)
      append_variable("RETURN", entity)
    end

    def delete(entity=nil)
      append_variable("DELETE", entity)
    end

    def destroy(entity=nil)
      append_variable("DETACH DELETE", entity)
    end

    def set(property, value, entity=nil)
      append("SET", entity) do |entity|
        "#{entity.variable_name}.#{property} = #{CypherRecord::Formatter.format_property(value)}"
      end
    end

    def realize
      query.map(&:realize).join(" ")
    end

    def resolve
      CypherRecord.engine.query(self.realize)
    end

    private

    def append(operator, entity, &block)
      appended_value = yield (focus_entity(entity))
      append_to_query(operator, appended_value)
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
