# frozen_string_literal: true
require "active_support/core_ext/hash"
require "active_support/core_ext/array"
require "active_support/core_ext/string"
require "securerandom"

require_relative "cypher_record/version"

# Helpers

require_relative "cypher_record/formatter"

# Query Engine
require_relative "cypher_record/engine"
require_relative "cypher_record/entity_adapter"

begin
  require "neo4j_ruby_driver"
  require_relative "cypher_record/engines/neo4j_engine"
rescue LoadError
  puts "Unable to load Neo4j Ruby driver. If this is a necessary dependency, make sure you include 'gem \"neo4j-ruby-driver\"' in your Gemfile"
end

# Models
require_relative "cypher_record/entity"
require_relative "cypher_record/node"
require_relative "cypher_record/relationship"
require_relative "cypher_record/path"

# Querying
require_relative "cypher_record/token"
require_relative "cypher_record/query"

# Backend adapters

module CypherRecord
  class Error < StandardError; end
  class AdapterError < StandardError; end
  class LabelError < StandardError; end

  def self.engine
    @engine ||= config.engine
  end

  def self.configure(&block)
    yield config
  end

  private

  class Config

    def self.engine
      @engine
    end

    def self.engine=(db_engine)
      raise(ArgumentError, "Database engine should be a CypherRecord::Engine") unless db_engine.is_a?(CypherRecord::Engine)
      @engine = db_engine
    end

    def self.reset!
      @engine = nil
    end

  end

  def self.config
    @config ||= CypherRecord::Config
  end

end
