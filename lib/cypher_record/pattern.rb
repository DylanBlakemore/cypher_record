module CypherRecord
  class Pattern

    attr_reader :tokens

    def self.from_node(node, as: :entity)
      CypherRecord::Pattern.new([entity_string(node, as)])
    end

    def initialize(tokens)
      @tokens = tokens
    end

    # Mutual relationships

    def related_to_node(node, via:, as: :entity)
      mutual_relation(
        entity_string(node, :entity),
        entity_string(via, as)
      )
    end

    def related_to_variable(node, via:, as: :entity)
      mutual_relation(
        entity_string(node, :variable),
        entity_string(via, as)
      )
    end

    # Right-pointing relationships

    def has_node(node, via:, as: :entity)
      right_relation(
        entity_string(node, :entity),
        entity_string(via, as)
      )
    end

    def has_variable(node, via:, as: :entity)
      right_relation(
        entity_string(node, :variable),
        entity_string(via, as)
      )
    end

    # Left-pointing relationships

    def belongs_to_node(node, via:, as: :entity)
      left_relation(
        entity_string(node, :entity),
        entity_string(via, as)
      )
    end

    def belongs_to_variable(node, via:, as: :entity)
      left_relation(
        entity_string(node, :variable),
        entity_string(via, as)
      )
    end

    def realize
      tokens.join(" ")
    end

    private

    LEFT = "<-"
    RIGHT = "->"
    MUTUAL = "-"

    def mutual_relation(node, relationship)
      CypherRecord::Pattern.new(
        [
          *tokens,
          MUTUAL,
          relationship,
          MUTUAL,
          node
        ]
      )
    end

    def right_relation(node, relationship)
      CypherRecord::Pattern.new(
        [
          *tokens,
          MUTUAL,
          relationship,
          RIGHT,
          node
        ]
      )
    end

    def left_relation(node, relationship)
      CypherRecord::Pattern.new(
        [
          *tokens,
          LEFT,
          relationship,
          MUTUAL,
          node
        ]
      )
    end

    def entity_string(entity, type)
      self.class.entity_string(entity, type)
    end

    def self.entity_string(entity, type)
      return entity.to_s unless entity.is_a?(CypherRecord::Entity)
      return entity.realize(type)
    end

  end
end
