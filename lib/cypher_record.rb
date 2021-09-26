# frozen_string_literal: true
require 'active_support/core_ext/hash'
require 'active_support/core_ext/array'
require 'securerandom'

require_relative "cypher_record/version"

# Helpers

require_relative "cypher_record/formatter"

# Migrations
require_relative "cypher_record/migration/property_definition"
require_relative "cypher_record/migration/node_definition"

# CLI

# Models
require_relative "cypher_record/entity"
require_relative "cypher_record/node"
require_relative "cypher_record/edge"

module CypherRecord
  class Error < StandardError; end
end
