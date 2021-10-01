module CypherRecord
  class Relationship < CypherRecord::Entity

    tokenize_with "[", "]"

    def self.create(left_node, right_node, **props)
      relationship = self.new(variable_name: variable_name, **props)
      path = CypherRecord::Path[relationship].from(left_node, as: :variable).to(right_node, as: :variable)
      CypherRecord::Query.new(entity: relationship)
        .match(left_node)
        .match(right_node)
        .create(path)
        .return
        .resolve
    end

  end
end
