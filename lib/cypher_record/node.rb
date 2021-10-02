module CypherRecord
  class Node < CypherRecord::Entity

    tokenize_with "(", ")"

    def self.has_many(key, via:)
      relationship_definition = create_path(singularize(key), via)
      relationships[key] = relationship_definition
    end

    def self.create(**props)
      CypherRecord::Query.new(entity: default_instance(props)).create.return.resolve
    end

    def self.find_or_create(**props)
      CypherRecord::Query.new(entity: default_instance(props)).merge.return.resolve
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

    def add_relation(singular_key, other_node)
      path = path_for(singular_key)
      raise(ArgumentError, "Related node is not a #{path.child}") unless other_node.is_a?(path.child)
      path.relationship.create(
        self,
        other_node
      )
    end

    private

    def path_for(key)
      self.class.relationships[self.class.pluralize(key)]
    end

    def self.default_instance(props)
      self.new(variable_name: variable_name, **props)
    end

    def self.pluralize(key)
      key.to_s.pluralize.to_sym
    end

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
