module CypherRecord
  class Node < CypherRecord::Entity

    tokenize_with "(", ")"

    def self.has_many(key, via:)
      relationship_definition = create_path(singularize(key), via)
      relationships[key] = relationship_definition
    end

    def self.create(**props)
      node = self.new(variable_name: variable_name, **props)
      CypherRecord::Query.new(entity: node).create.return.resolve
    end

    def self.relationships
      @relationships ||= {}
    end

    def method_missing(method_name, *args, **kwargs, &block)
      if path = self.class.relationships[method_name]
        CypherRecord::Query.new(entity: path.child).match(path.from(self)).where(self, id: self.id)
      else
        super
      end
    end
  
    def respond_to?(method_name, include_private = false)
      super || self.class.relationships[method_name].present?
    end

    private

    def self.singularize(key)
      key.to_s.singularize.to_sym
    end

    def self.create_path(node, relation)
      CypherRecord::Path[resolve_key(relation)].to(resolve_key(node))
    end

    def self.resolve_key(key)
      CypherRecord::ClassResolver.resolve(key, self)
    end

  end
end
