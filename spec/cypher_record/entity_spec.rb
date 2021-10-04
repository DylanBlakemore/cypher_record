require "spec_helper"

RSpec.describe CypherRecord::Entity do
  
  class DummyCypherEntityClass < CypherRecord::Entity
    property :foo
    property :bar

    primary_key :id
  end

  let(:klass) { DummyCypherEntityClass }

  let(:entity) { klass.new(variable_name: :n, id: 123, foo: "Foo", bar: 1) }

  describe ".property_names" do
    it { expect(klass.property_names).to eq([:foo, :bar, :id]) }
  end

  describe "#properties" do
    it { expect(entity.properties).to eq({foo: "Foo", bar: 1, id: 123}) }
  end

  describe "#primary_key" do
    it "can define a primary key" do
      expect(entity.primary_key).to eq(:id)
      expect(entity.id).to eq(123)
    end
  end

  it "assigns the correct instance variables" do
    expect(entity.foo).to eq("Foo")
    expect(entity.bar).to eq(1)
  end

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_entity")
    end
  end

  describe "#realize" do
    context "entity" do
      it "returns the entity token" do
        expect(described_class.realize).to eq("cypher_record_entity:CypherRecord_Entity")
        expect(described_class.realize(:entity)).to eq("cypher_record_entity:CypherRecord_Entity")
      end
    end

    context "variable" do
      it "returns the variable token" do
        expect(described_class.realize(:variable)).to eq("cypher_record_entity")
      end
    end
  end

  describe "#label" do
    it "returns the class name" do
      expect(entity.label).to eq("DummyCypherEntityClass")
    end

    context "with a namespaced class" do
      module Namespaced
        class DummyCypherEntityClass < CypherRecord::Entity
          property :foo
          property :bar
        end
      end

      let(:klass) { Namespaced::DummyCypherEntityClass }

      it "replaces :: with _" do
        expect(entity.label).to eq("Namespaced_DummyCypherEntityClass")
      end
    end
  end

  describe ".all" do
    it "returns a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::Entity.all.realize).to eq("MATCH cypher_record_entity:CypherRecord_Entity")
      expect(DummyCypherEntityClass.all.realize).to eq("MATCH dummy_cypher_entity_class:DummyCypherEntityClass")
    end
  end

  describe ".where" do
    it "returns the correct 'where' query" do
      expect(CypherRecord::Entity.where(foo: "Foo").realize).to eq("MATCH cypher_record_entity:CypherRecord_Entity WHERE cypher_record_entity.foo = 'Foo'")
      expect(DummyCypherEntityClass.where(foo: "Foo").realize).to eq("MATCH dummy_cypher_entity_class:DummyCypherEntityClass WHERE dummy_cypher_entity_class.foo = 'Foo'")
    end
  end

  describe ".find" do
    it "creates the query to find the first entry by the primary key" do
      expect(CypherRecord.driver).to receive(:query).with("MATCH dummy_cypher_entity_class_1234:DummyCypherEntityClass {id: 1234} RETURN dummy_cypher_entity_class_1234 LIMIT 1")
      DummyCypherEntityClass.find(1234)
    end

    context "when a primary key is not defined for the model" do
      it "returns an appropriate error" do
        expect { CypherRecord::Entity.find(1234) }.to raise_error(NotImplementedError, "Entity#find is only available for models that define a primary key")
      end
    end
  end

  describe ".find_by" do
    let(:query_string) do
      "MATCH dummy_cypher_entity_class:DummyCypherEntityClass {foo: 'Foo'} RETURN dummy_cypher_entity_class LIMIT 1"
    end

    it "creates the query to find the entity" do
      expect(CypherRecord.driver).to receive(:query).with(query_string)
      DummyCypherEntityClass.find_by(foo: "Foo")
    end
  end
end
