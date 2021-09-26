module CypherRecord
  class Entity

    attr_reader :id, :properties

    def self.properties(*required_props, **optional_props)
      @required_props = required_props
      @optional_props = optional_props

      (required_props + optional_props.keys).each do |prop|
        attr_reader prop
      end
    end

    def self.type
      self.to_s
    end

    def initialize(id: SecureRandom.alphanumeric(3), **props)
      @id = id
      validate_props(props)
      @properties = optional_props.merge(props)
      @properties.each do |key, value|
        self.instance_variable_set("@#{key}", value)
      end
    end

    def type
      self.class.type
    end

    def property_string
      "{#{formatted_properties}}"
    end

    private

    def formatted_properties
      property_keys.map do |property_key|
        "#{property_key}: #{CypherRecord::Formatter.format_property(properties[property_key])}" if properties[property_key]
      end.join(", ")
    end

    def required_props
      self.class.instance_variable_get(:@required_props) || []
    end

    def optional_props
      self.class.instance_variable_get(:@optional_props) || {}
    end

    def property_keys
      @property_keys ||= required_props + optional_props.keys
    end

    def validate_props(props)
      missing_props = (required_props - props.keys)
      raise(ArgumentError, "Required properties #{missing_props.join(", ")} missing for #{self.class}") if missing_props.present?
    end

  end
end
