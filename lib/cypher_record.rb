# frozen_string_literal: true
require "active_support/core_ext/hash"
require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "active_attr"
require "securerandom"

require_relative "cypher_record/version"

# Helpers

require_relative "cypher_record/util/format"
require_relative "cypher_record/util/class_resolver"

# Query Driver
require_relative "cypher_record/driver"
require_relative "cypher_record/entity_adapter"

# Models
require_relative "cypher_record/entity"
require_relative "cypher_record/node"
require_relative "cypher_record/relationship"
require_relative "cypher_record/path"

# Querying
require_relative "cypher_record/token"
require_relative "cypher_record/query_methods/base"
require_relative "cypher_record/query_methods/filtering"
require_relative "cypher_record/query_methods/writing"
require_relative "cypher_record/query"

# Backend adapters

require_relative "cypher_record/plugins/neo4j/neo4j_includes"

module CypherRecord
  class Error < StandardError; end
  class AdapterError < StandardError; end
  class LabelError < StandardError; end
  class EntityTypeError < StandardError; end

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
