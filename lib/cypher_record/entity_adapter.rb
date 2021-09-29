module CypherRecord
  class EntityAdapter

    protected

    def self.resolve_label(label)
      label.to_s.gsub("_", "::")
    end

  end
end
