module CypherRecord
  class Token

    attr_reader :operator, :operand

    def initialize(operator, operand)
      @operator = operator
      @operand = operand
    end

    def realize
      [operator, operand&.to_s].compact.join(" ")
    end

  end
end
