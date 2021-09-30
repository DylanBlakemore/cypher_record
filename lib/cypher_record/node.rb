module CypherRecord
  class Node < CypherRecord::Entity

    tokenize_with "(", ")"

    def self.has_many(related_node, via:)
      relationships << CypherRecord::RelationshipDefinition.new(
        self,
        resolve_key(via),
        resolve_key(related_node.to_s.singularize.to_sym)
      )
    end

    def self.create(**props)
      node = self.new(variable_name: variable_name, **props)
      CypherRecord::Query.new(entity: node).create.return.resolve
    end

    def self.relationships
      @relationships ||= []
    end

    private

    def self.resolve_key(key)
      CypherRecord::ClassResolver.resolve(key, self)
    end

  end
end
