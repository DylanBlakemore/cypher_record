module CypherRecord
  module Dsl
    module Relatable

      def relationship_to(other, relationship=Relationship.new)
        Pattern.new([
          self,
          Between,
          relationship_object(relationship),
          To,
          other
        ])
      end

      def relationship_from(other, relationship=Relationship.new)
        Pattern.new([
          self,
          From,
          relationship_object(relationship),
          Between,
          other
        ])
      end

      def relationship_between(other, relationship=Relationship.new)
        Pattern.new([
          self,
          Between,
          relationship_object(relationship),
          Between,
          other
        ])
      end

      private

      def relationship_object(relationship)
        return relationship if relationship.is_a?(Relationship)
        return Relationship.new(relationship) if relationship.is_a?(String)
        raise ArgumentError, "Relationship must be a CypherRecord::Dsl::Relationship or String"
      end

    end
  end
end
