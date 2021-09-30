module CypherRecord
  class RelationshipDefinition

    attr_reader :parent, :relation, :child

    def initialize(parent, relation, child)
      @parent = parent
      @relation = relation
      @child = child
    end

    def ==(other)
      other.is_a?(self.class) &&
      other.parent == parent &&
      other.relation == relation &&
      other.child == child
    end

  end
end
