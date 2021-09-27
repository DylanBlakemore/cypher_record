module CypherRecord
  class Token

    attr_reader :operator, :operand

    def initialize(operator, operand)
      @operator = operator
      @operand = operand
    end

    def to_s
      [operator, operand&.to_s].compact.join(" ")
    end

  end
end
