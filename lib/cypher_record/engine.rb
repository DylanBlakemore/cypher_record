module CypherRecord
  class Engine

    def query(query)
      raise(NotImplementedError, "#{self.class} must implement a 'query' method")
    end

  end
end
