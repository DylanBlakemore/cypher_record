module CypherRecord
  class Node < CypherRecord::Entity

    def self.create(**props)
      node = self.new(variable_name: default_variable_name, **props)
      CypherRecord::Query.new(entity: node).create.return.resolve
    end

    private

    def entity_token
      "(#{base_entity_token})"
    end

    def variable_token
      "(#{variable_name})"
    end

  end
end
