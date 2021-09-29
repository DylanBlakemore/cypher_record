begin
  require "neo4j_ruby_driver"
  require_relative "../engines/neo4j_engine"
rescue LoadError => e
  puts "Unable to load Neo4j Ruby driver with error #{e}. If this is a necessary dependency, make sure you include 'gem \"neo4j-ruby-driver\"' in your Gemfile"
end
