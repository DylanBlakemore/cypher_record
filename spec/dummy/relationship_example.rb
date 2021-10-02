module CypherRecord
  class RelationshipExample < CypherRecord::Relationship

    property :foo
    property :bar
    primary_key :id

  end
end
