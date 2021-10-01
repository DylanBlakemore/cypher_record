module CypherRecord
  class Path

    attr_reader :parent, :relationship, :child

    def self.[](relationship)
      self.new(relationship: relationship)
    end

    def initialize(parent: nil, relationship: nil, child: nil)
      @relationship = relationship
      @child = child
      @parent = parent
    end

    def from(entity, as: :entity)
      parent_value = case as
        when :entity
          entity
        when :variable
          entity.realize(:variable)
        end
      CypherRecord::Path.new(parent: parent_value, relationship: relationship, child: child)
    end

    def to(entity, as: :entity)
      child_value = case as
      when :entity
        entity
      when :variable
        entity.realize(:variable)
      end
      CypherRecord::Path.new(parent: parent, relationship: relationship, child: child_value)
    end

    def realize(type=:entity)
      "#{entity_string(parent)}-#{entity_string(relationship, type)}->#{entity_string(child)}"
    end

    def ==(other)
      other.is_a?(self.class) && other.realize == self.realize
    end

    private

    def entity_string(value, type=:entity)
      return value.to_s unless value.respond_to?(:realize)
      return value.realize(type)
    end

  end
end
