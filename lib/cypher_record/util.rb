module CypherRecord
  module Util

    def self.determine_class(key, klass, default=nil)
      camelized_key = key.to_s.camelize
      camelized_key.safe_constantize ||
      "#{klass.to_s.deconstantize}::#{camelized_key}".safe_constantize ||
      default
    end

  end
end
