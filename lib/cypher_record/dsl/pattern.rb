module CypherRecord
  module Dsl
    class Pattern

      include CypherRecord::Dsl::Relatable

      def self.from_string(pattern)
        Pattern.new([Token.new(pattern)])
      end

      attr_reader :tokens

      def initialize(tokens)
        @tokens = tokens
      end

      def make
        tokens.map(&:make).join
      end

      private

      # Will be used to turn a string into a full pattern object
      def self.tokenize(pattern)
        pattern.split(/(?<=\))|(?=\()|(?<=\])|(?=\[)/)
      end

    end
  end
end
