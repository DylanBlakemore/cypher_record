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
      self.to_s
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

    def property_string
      "{#{formatted_properties}}"
    end

    def to_s
      str = ""
      str << variable_name.to_s if variable_name
      str << ":#{label}"
      str << " #{property_string}" if properties.present?
      str
    end

    private

    def self.default_variable_name
      @default_variable_name ||= self.to_s.underscore.downcase
    end

    def formatted_properties
      property_keys.map do |property_key|
        "#{property_key}: #{CypherRecord::Formatter.format_property(properties[property_key])}" if properties[property_key]
      end.join(", ")
    end

    def property_keys
      @property_keys ||= self.class.instance_variable_get(:@properties) || []
    end

  end
end
