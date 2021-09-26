module CypherRecord
  class Edge < CypherRecord::Entity

    def to_s
      str = "["
      str << id.to_s if id
      str << ":#{type}"
      str << " #{property_string}" if properties.present?
      str << "]"
      str
    end

    private

  end
end
