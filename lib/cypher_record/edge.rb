module CypherRecord
  class Edge < CypherRecord::Entity

    def self.create(left_node, right_node, direction: :forwards, **props)
      edge = self.new(id: variable_name, **props)
      relationship = CypherRecord::Relationship.new(left_node, edge, right_node, direction).edge_only
      CypherRecord::Query.new.match(left_node).match(right_node).create(relationship).return(edge).resolve
    end

    def self.type
      super.underscore.upcase
    end

    def to_s
      "[#{super}]"
    end

    private

  end
end
