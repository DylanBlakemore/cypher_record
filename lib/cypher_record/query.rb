module CypherRecord
  class Query

    attr_reader :clauses, :metadata

    def initialize(clauses=[], metadata={})
      @clauses = clauses
      @metadata = metadata
    end

    def make
      clauses.map(&:make).join(" ")
    end

    def match(pattern)
      concat(CypherRecord::Dsl::Match.new(pattern))
    end

    def create(pattern)
      concat(CypherRecord::Dsl::Create.new(pattern))
    end

    def merge(pattern)
      concat(CypherRecord::Dsl::Merge.new(pattern))
    end

    def return(*return_values)
      concat(CypherRecord::Dsl::Return.new(*return_values))
    end

    private

    def concat(clause, new_metadata={})
      self.class.new(
        clauses + [clause],
        metadata.merge(new_metadata)
      )
    end

  end
end
