module CypherRecord
  class Entity

    include ActiveAttr::Attributes
    include ActiveAttr::AttributeDefaults
    include ActiveAttr::TypecastedAttributes
    include ActiveAttr::MassAssignment

    attr_reader :variable_name, :id

    # Alias to ActiveAttr method
    class << self
      alias_method :property, :attribute
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

    def self.find(id)
      all.where(id: id).return.limit(1).resolve&.first
    end

    ##

    def initialize(id: nil, variable_name: self.class.variable_name, **props)
      @variable_name = [variable_name, id&.to_s].compact.join("_").to_sym
      @id = id
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

    private

    def self.entity_token
      build_token(left_tokenizer, base_entity_token, right_tokenizer)
    end

    def self.variable_token
      build_token(left_tokenizer, variable_name, right_tokenizer)
    end

    def entity_token
      self.class.build_token(left_tokenizer, base_entity_token, right_tokenizer)
    end

    def variable_token
      self.class.build_token(left_tokenizer, variable_name, right_tokenizer)
    end

    def self.build_token(left, middle, right)
      "#{left}#{middle}#{right}"
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
      end.join(", ")
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

    def left_tokenizer
      @left_tokenizer ||= self.class.left_tokenizer
    end

    def right_tokenizer
      @right_tokenizer ||= self.class.right_tokenizer
    end

  end
end
