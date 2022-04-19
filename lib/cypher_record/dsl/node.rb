module CypherRecord
  module Dsl
    class Node < CypherRecord::Dsl::Entity

      include Relatable

      def make
        "(#{formatted_data})"
      end

    end
  end
end
