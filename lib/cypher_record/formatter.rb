module CypherRecord
  class Formatter

    def self.format_property(property)
      case property
      when String
        format_string_property(property)
      else
        property.to_s
      end
    end

    private

    def self.format_string_property(property)
      "'#{property}'"
    end

  end
end
