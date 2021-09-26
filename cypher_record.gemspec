# frozen_string_literal: true

require_relative "lib/cypher_record/version"

Gem::Specification.new do |spec|
  spec.name          = "cypher_record"
  spec.version       = CypherRecord::VERSION
  spec.authors       = ["Dylan Blakemore"]
  spec.email         = ["dylan.blakemore@gmail.com"]

  spec.summary       = "Cypher graphing language for Ruby and Rails."
  spec.description   = "Provides a DSL similar to Active Record for easy creation of queries in the Cypher graph langaue."
  spec.homepage      = "https://github.com/DylanBlakemore"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DylanBlakemore/cypher_record"
  spec.metadata["changelog_uri"] = "https://github.com/DylanBlakemore/cypher_record"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
