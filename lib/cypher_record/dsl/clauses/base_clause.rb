module CypherRecord
  module Dsl
    class BaseClause

      self.abstract_class = true

      def build
        raise NotImplementedError, "Clause must implement '#{build}' method"
      end

    end
  end
end
