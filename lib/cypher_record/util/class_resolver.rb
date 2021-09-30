module CypherRecord
  class ClassResolver

    def self.resolve(key, caller_class)
      camel_key = camelize(key)
      caller_namespace = namespace(caller_class)
      constantize_or_raise(camel_key, caller_namespace)
    end

    private

    def self.constantize_or_raise(key, namespace)
      "#{namespace}::#{key}".safe_constantize ||
      key.safe_constantize ||
      raise(CypherRecord::EntityTypeError, "Class not found for entity #{key}")
    end

    def self.camelize(key)
      key.to_s.camelize
    end

    def self.namespace(caller_class)
      caller_class.to_s.deconstantize
    end

  end
end
