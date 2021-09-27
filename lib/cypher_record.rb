# frozen_string_literal: true
require "active_support/core_ext/hash"
require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "securerandom"

require_relative "cypher_record/version"

# Helpers

require_relative "cypher_record/formatter"

# Migrations
require_relative "cypher_record/migration/property_definition"
require_relative "cypher_record/migration/node_definition"

# CLI

# Query Engine
require_relative "cypher_record/engine"

# Models
require_relative "cypher_record/entity"
require_relative "cypher_record/node"
require_relative "cypher_record/edge"
require_relative "cypher_record/relationship"

#Querying
require_relative "cypher_record/token"
require_relative "cypher_record/query"

module CypherRecord
  class Error < StandardError; end

  def self.engine
    @engine ||= config.engine
  end

  def self.configure(&block)
    yield config
  end

  private

  class Config
    attr_accessor :engine
  end

  def self.config
    @config ||= Config.new
  end

end
