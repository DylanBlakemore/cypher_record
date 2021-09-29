
require_relative "../adapters/neo4j_adapter"

module CypherRecord
  module Engines
    class Neo4jEngine < CypherRecord::Engine

      attr_reader :uri, :username, :password

      def initialize(uri, username, password)
        @uri = uri
        @username = username
        @password = password
      end

      def query(query)
        results(query).each_entry.map do |entry|
          CypherRecord::Adapters::Neo4jAdapter.adapt(entry)
        end
      end

      private

      def results(query)
        driver.session do |session|
          session.run(query)
        end
      end

      def driver
        @driver ||= Neo4j::Driver::GraphDatabase.driver(uri, auth, encryption: false)
      end

      def auth
        @auth ||= Neo4j::Driver::AuthTokens.basic(username, password)
      end

    end
  end
end
