module CypherRecord
  class Relationship < CypherRecord::Entity

    def self.create(left_node, right_node, **props)
      relationship = self.new(variable_name: default_variable_name, **props)
      pattern = CypherRecord::Pattern.from_node(left_node, as: :variable).has_variable(right_node, via: relationship)
      CypherRecord::Query.new.match(left_node).match(right_node).create(pattern).return(relationship).resolve
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
