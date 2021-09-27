module CypherRecord
  class Node < CypherRecord::Entity

    def self.create(**props)
      entity = self.new(variable_name: default_variable_name, **props)
      CypherRecord::Query.new.create(entity).return(entity).resolve
    end

    def to_s
      "(#{super})"
    end

    private

  end
end
