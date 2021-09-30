module CypherRecord
  class Entity

    include ActiveAttr::Attributes
    include ActiveAttr::AttributeDefaults
    include ActiveAttr::TypecastedAttributes
    include ActiveAttr::MassAssignment

    attr_reader :variable_name

    # Alias to ActiveAttr method
    class << self
      alias_method :property, :attribute
    end

    def self.label
      self.to_s.gsub("::", "_")
    end

    def initialize(variable_name: nil, **props)
      @variable_name = variable_name
      super(**props)
    end

    def label
      self.class.label
    end

    def realize(token_type = :entity)
      case token_type
      when :entity
        entity_token
      when :variable
        variable_token
      end
    end

    def properties
      attributes.symbolize_keys
    end

    private

    def entity_token
      raise(NotImplementedError, "#{self.class} must implement 'entity_token' method")
    end

    def variable_token
      raise(NotImplementedError, "#{self.class} must implement 'variable_token' method")
    end

    def base_entity_token
      @base_entity_token ||= begin
        token_string = ""
        token_string << variable_name.to_s if variable_name
        token_string << ":#{label}"
        token_string << " #{property_string}" if properties.present?
        token_string
      end
    end

    def property_string
      "{#{formatted_properties}}"
    end

    def self.default_variable_name
      @default_variable_name ||= self.to_s.underscore.downcase
    end

    def formatted_properties
      properties.map do |(property, value)|
        "#{property}: #{CypherRecord::Format.property(value)}" if value
      end.join(", ")
    end

  end
end
