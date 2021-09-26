module CypherRecord
  class Node < CypherRecord::Entity

    def to_s
      "(#{id}:#{type} #{property_string})"
    end

    private

  end
end
