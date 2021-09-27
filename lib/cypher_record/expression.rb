module CypherRecord
  class Expression

    attr_reader :operator, :operand, :arguments

    def initialize(expression)
      @operator = expression[0]
      @operand = expression[1]
      @arguments = expression[2]
    end

    def resolve

    end

  end
end
