module CypherRecord
  class Entity

    include ActiveAttr::Attributes
    include ActiveAttr::AttributeDefaults
    include ActiveAttr::TypecastedAttributes
    include ActiveAttr::MassAssignment

    attr_reader :variable_name

    # Alias to ActiveAttr method
    class << self
      alias_method :property, :attribute
    end

    def self.primary_key(key, *args, **kwargs)
      property(key, *args, **kwargs)
      @primary_key = key
    end

    def self.property_names
      self.attribute_names.map(&:to_sym)
    end

    def self.tokenize_with(left, right)
      @left_tokenizer = left
      @right_tokenizer = right
    end

    def self.variable_name
      self.to_s.underscore.downcase.gsub("/", "_")
    end

    def self.label
      self.to_s.gsub("::", "_")
    end

    ## Queries

    def self.all
      CypherRecord::Query.new(entity: self).match
    end

    def self.where(**props)
      all.where(**props)
    end

    def self.find(primary_key_value)
      raise(NotImplementedError, "Entity#find is only available for models that define a primary key") unless @primary_key
      find_by(@primary_key => primary_key_value)
    end

    def self.find_by(**props)
      CypherRecord::Query.new(entity: self.new(**props)).match.return.limit(1).resolve&.first
    end

    ##

    def initialize(variable_name: self.class.variable_name, **props)
      @variable_name = self.class.generate_variable_name(variable_name, props)
      super(**props)
    end

    def label
      self.class.label
    end

    def realize(token_type = :entity)
      case token_type
      when :entity
        entity_token
      when :variable
        variable_token
      end
    end

    def self.realize(token_type = :entity)
      case token_type
      when :entity
        entity_token
      when :variable
        variable_token
      end
    end

    def properties
      attributes.symbolize_keys
    end

    def primary_key
      @primary_key ||= self.class.instance_variable_get(:@primary_key)
    end

    private

    def self.generate_variable_name(base_variable_name, props)
      name = [base_variable_name]
      name << props[@primary_key] if @primary_key
      name.compact.join("_").to_sym
    end

    def self.entity_token
      build_token(base_entity_token)
    end

    def self.variable_token
      build_token(variable_name)
    end

    def entity_token
      self.class.build_token(base_entity_token)
    end

    def variable_token
      self.class.build_token(variable_name)
    end

    def self.build_token(middle)
      "#{left_tokenizer}#{middle}#{right_tokenizer}"
    end

    def self.build_entity_token_base(variable_name, label, property_string=nil)
      token_string = ""
      token_string << variable_name.to_s if variable_name
      token_string << ":#{label}"
      token_string << " #{property_string}" if property_string.present?
      token_string
    end

    def self.base_entity_token
      @base_entity_token ||= build_entity_token_base(variable_name, label)
    end

    def base_entity_token
      @base_entity_token ||= self.class.build_entity_token_base(variable_name, label, property_string)
    end

    def property_string
      @property_string ||= "{#{formatted_properties}}" if formatted_properties.present?
    end

    def formatted_properties
      @formatted_properties ||= properties.map do |(property, value)|
        "#{property}: #{CypherRecord::Format.property(value)}" if value
      end.compact.join(", ")
    end

    def self.left_tokenizer
      @left_tokenizer || begin
        self.superclass.left_tokenizer
      rescue NoMethodError
        nil
      end
    end

    def self.right_tokenizer
      @right_tokenizer || begin
        self.superclass.right_tokenizer
      rescue NoMethodError
        nil
      end
    end

  end
end
