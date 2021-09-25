module CypherRecord
  class NodeDefinition

    attr_reader :node_name

    def initialize(node_name)
      @node_name = node_name
    end

    def string(name, default: nil, null: true)
      add_property(name, [String], null, default)
    end

    def integer(name, default: nil, null: true)
      add_property(name, [Integer], null, default)
    end

    def boolean(name, default: nil, null: true)
      add_property(name, [TrueClass, FalseClass], null, default)
    end

    def float(name, default: nil, null: true)
      add_property(name, [Float], null, default)
    end

    def properties
      @properties ||= []
    end

    private

    def add_property(name, type, null, default)
      properties << CypherRecord::PropertyDefinition.new(
        name,
        type,
        null,
        default
      )
    end

  end
end
