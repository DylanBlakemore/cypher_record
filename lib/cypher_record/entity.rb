module CypherRecord
  class Entity

    attr_reader :variable_name, :properties

    def self.properties(*props)
      @properties = props
      props.each do |prop|
        attr_reader prop
      end
    end

    def self.label
      self.to_s.gsub("::", "_")
    end

    def initialize(variable_name: nil, **props)
      @variable_name = variable_name
      @properties = props
      property_keys.each do |key|
        self.instance_variable_set("@#{key}", props[key])
      end
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
      property_keys.map do |property_key|
        "#{property_key}: #{CypherRecord::Format.property(properties[property_key])}" if properties[property_key]
      end.join(", ")
    end

    def property_keys
      @property_keys ||= self.class.instance_variable_get(:@properties) || []
    end

  end
end
