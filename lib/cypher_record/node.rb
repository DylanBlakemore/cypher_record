module CypherRecord
  class Node < CypherRecord::Entity

    tokenize_with "(", ")"

    def self.create(**props)
      node = self.new(variable_name: variable_name, **props)
      CypherRecord::Query.new(entity: node).create.return.resolve
    end

  end
end
