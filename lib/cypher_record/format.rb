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
      "#{entity_property(variable_name, property)} = #{property(value)}"
    end

    private

    def self.string_property(property)
      "'#{property}'"
    end

  end
end
