module CypherRecord
  class Relationship < CypherRecord::Entity

    tokenize_with "[", "]"

    def self.create(left_node, right_node, **props)
      relationship = self.new(variable_name: variable_name, **props)
      path = CypherRecord::Path.from_node(left_node, as: :variable).has_variable(right_node, via: relationship)
      CypherRecord::Query.new(entity: relationship)
        .match(left_node)
        .match(right_node)
        .create(path)
        .return
        .resolve
    end

  end
end
