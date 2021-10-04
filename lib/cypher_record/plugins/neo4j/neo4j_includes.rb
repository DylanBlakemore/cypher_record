begin
  require "neo4j_ruby_driver"
  require_relative "neo4j_adapter"
  require_relative "neo4j_driver"
rescue LoadError => e
  puts "Unable to load Neo4j Ruby driver with error #{e}. If this is a necessary dependency, make sure you include 'gem \"neo4j-ruby-driver\"' in your Gemfile"
end
