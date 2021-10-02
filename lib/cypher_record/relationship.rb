module CypherRecord
  class Relationship < CypherRecord::Entity

    tokenize_with "[", "]"

    def self.create(left_node, right_node, **props)
      relationship = self.new(variable_name: variable_name, **props)
      path = CypherRecord::Path[relationship].from(left_node, as: :variable).to(right_node, as: :variable)
      CypherRecord::Query.new(entity: relationship)
        .merge(left_node)
        .merge(right_node)
        .merge(path)
        .return
        .resolve
    end

  end
end
