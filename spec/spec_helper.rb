require "bundler/setup"
require "pry"
require "pry-byebug"
require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter %r{/cypher_record/plugins/.*/.*_includes.rb}
  minimum_coverage 100
  maximum_coverage_drop 0
end

require "cypher_record"
require_relative "dummy/child_node_example"
require_relative "dummy/relationship_example"
require_relative "dummy/mutual_relationship_example"
require_relative "dummy/node_example"

Bundler.setup

def suppress_log_output
  allow(STDOUT).to receive(:puts) # this disables puts
end

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

RSpec.configure do |config|
  config.before(:each) do
    suppress_log_output
    CypherRecord::Config.reset!
  end

  config.before(:each, type: :neo4j) do
    subject.query("MATCH (n) DETACH DELETE n")
  end
end
