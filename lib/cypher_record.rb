# frozen_string_literal: true

require_relative "cypher_record/version"

# Migrations
require_relative "cypher_record/migration/property_definition"
require_relative "cypher_record/migration/node_definition"

module CypherRecord
  class Error < StandardError; end
end
