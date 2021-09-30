module CypherRecord
  class NodeExample < CypherRecord::Node

    property :title
    property :description

    has_many :child_node_examples, via: :relationship_example
    has_many :node_examples, via: :mutual_relationship_example

  end
end
