module CypherRecord
  class Relationship < CypherRecord::Entity

    def self.create(left_node, right_node, **props)
      relationship = self.new(variable_name: default_variable_name, **props)
      path = CypherRecord::Path.from_node(left_node, as: :variable).has_variable(right_node, via: relationship)
      CypherRecord::Query.new(entity: relationship)
        .match(left_node)
        .match(right_node)
        .create(path)
        .return
        .resolve
    end

    private

    def entity_token
      "[#{base_entity_token}]"
    end

    def variable_token
      "[#{variable_name}]"
    end

  end
end
