module CypherRecord
  class PropertyDefinition

    attr_reader :name, :type, :null, :default

    def initialize(name, type, null, default)
      raise(ArgumentError, "Invalid default #{default} supplied for property '#{name}', expected #{type}") unless default.nil? || default.is_a?(type)
      @name = name
      @type = type
      @null = null
      @default = default
    end

  end
end
