module CypherRecord
  class Query

    attr_reader :query

    def initialize(query=[])
      @query = query
    end

    def merge(entity)
      CypherRecord::Query.new(append_token("MERGE", entity.realize))
    end

    def create(entity)
      CypherRecord::Query.new(append_token("CREATE", entity.realize))
    end

    def match(entity)
      CypherRecord::Query.new(append_token("MATCH", entity.realize))
    end

    def return(entity)
      CypherRecord::Query.new(append_token("RETURN", entity.variable_name))
    end

    def delete(entity)
      CypherRecord::Query.new(append_token("DELETE", entity.variable_name))
    end

    def destroy(entity)
      CypherRecord::Query.new(append_token("DETACH DELETE", entity.variable_name))
    end

    def set(entity, property, value)
      CypherRecord::Query.new(
        append_token(
            "SET", "#{entity.variable_name}.#{property} = #{CypherRecord::Formatter.format_property(value)}"
          )
        )
    end

    def realize
      query.map(&:realize).join(" ")
    end

    def resolve
      CypherRecord.engine.query(self.realize)
    end

    private

    def append_token(operator, operand)
      query.append(CypherRecord::Token.new(operator, operand))
    end

  end
end
