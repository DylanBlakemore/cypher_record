module CypherRecord
  module Dsl
    class Relationship < CypherRecord::Dsl::Entity

      def make
        "[#{formatted_data}]"
      end

    end
  end
end
