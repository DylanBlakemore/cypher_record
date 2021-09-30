module CypherRecord
  class Node < CypherRecord::Entity

    tokenize_with "(", ")"

    def self.has_many(key, via:)
      relationship_definition = create_relationship_definition(singularize(key), via)
      relationships[key] = relationship_definition
    end

    def self.create(**props)
      node = self.new(variable_name: variable_name, **props)
      CypherRecord::Query.new(entity: node).create.return.resolve
    end

    def self.relationships
      @relationships ||= {}
    end

    private

    def self.singularize(key)
      key.to_s.singularize.to_sym
    end

    def self.create_relationship_definition(node, relation)
      CypherRecord::RelationshipDefinition.new(
        self,
        resolve_key(relation),
        resolve_key(node)
      )
    end

    def self.resolve_key(key)
      CypherRecord::ClassResolver.resolve(key, self)
    end

  end
end
