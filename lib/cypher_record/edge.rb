module CypherRecord
  class Edge < CypherRecord::Entity

    def self.type
      super.underscore.upcase
    end

    def to_s
      "[#{super}]"
    end

    private

  end
end
