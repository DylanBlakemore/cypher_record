module CypherRecord
  class Format

    def self.property_keys(variable, properties)
      properties.map do |property|
        entity_property(variable, property)
      end.join(", ")
    end

    def self.entity_property(variable, property)
      "#{variable}.#{property}"
    end

    def self.property(property)
      case property
      when String
        string_property(property)
      else
        property.to_s
      end
    end

    def self.property_assignment(variable_name, property, value)
      if property == :id # This is a special case. ID is handled through a function rather than a true property
        "ID(#{variable_name}) = #{value}"
      else
        "#{entity_property(variable_name, property)} = #{property(value)}"
      end
    end

    private

    def self.string_property(property)
      "'#{property}'"
    end

  end
end
