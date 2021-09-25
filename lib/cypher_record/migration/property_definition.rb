module CypherRecord
  class PropertyDefinition

    attr_reader :name, :types, :null, :default

    def initialize(name, types, null, default)
      raise(ArgumentError, "Invalid default #{default} supplied for property '#{name}', expected #{types.join(",")}") unless default.nil? || types.include?(default.class)
      @name = name
      @types = types
      @null = null
      @default = default
    end

  end
end
