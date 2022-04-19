# frozen_string_literal: true
require "active_support/core_ext/hash"
require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "active_attr"
require "securerandom"

require_relative "cypher_record/version"

# Query Driver
require_relative "cypher_record/driver"
require_relative "cypher_record/entity_adapter"

# Backend adapters

require_relative "cypher_record/plugins/neo4j/neo4j_includes"

# DSL

require_relative "cypher_record/dsl/clauses/match"
require_relative "cypher_record/dsl/clauses/return"
require_relative "cypher_record/dsl/clauses/create"
require_relative "cypher_record/dsl/clauses/merge"

require_relative "cypher_record/dsl/token"
require_relative "cypher_record/dsl/relationship_directions"
require_relative "cypher_record/dsl/property"
require_relative "cypher_record/dsl/property_set"
require_relative "cypher_record/dsl/relatable"
require_relative "cypher_record/dsl/pattern"
require_relative "cypher_record/dsl/entity_property"
require_relative "cypher_record/dsl/entity"
require_relative "cypher_record/dsl/relationship"
require_relative "cypher_record/dsl/node"

require_relative "cypher_record/query"

module CypherRecord
  class Error < StandardError; end

  def self.driver
    @driver ||= config.driver
  end

  def self.configure(&block)
    yield config
  end

  private

  class Config

    def self.driver
      @driver
    end

    def self.driver=(db_driver)
      raise(ArgumentError, "Database driver should be a CypherRecord::Driver") unless db_driver.is_a?(CypherRecord::Driver)
      @driver = db_driver
    end

    def self.reset!
      @driver = nil
    end

  end

  def self.config
    @config ||= CypherRecord::Config
  end

end
