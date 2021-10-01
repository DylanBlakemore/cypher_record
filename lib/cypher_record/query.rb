module CypherRecord
  class Query

    include CypherRecord::QueryMethods::Writing
    include CypherRecord::QueryMethods::Filtering

    attr_reader :query, :base_entity

    def initialize(query: [], entity: nil)
      @query = query
      @base_entity = entity
    end

    def realize
      query.map(&:realize).join(" ")
    end

    def resolve
      CypherRecord.engine.query(self.realize)
    end

  end
end
