require "spec_helper"

RSpec.describe CypherRecord::Entity do
  
  class DummyCypherEntityClass < CypherRecord::Entity
    property :foo
    property :bar
  end

  let(:klass) { DummyCypherEntityClass }

  let(:entity) { klass.new(variable_name: :n, foo: "Foo", bar: 1) }

  describe ".property_names" do
    it { expect(klass.property_names).to eq([:foo, :bar]) }
  end

  describe "#properties" do
    it { expect(entity.properties).to eq({foo: "Foo", bar: 1}) }
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
    it "creates the query to find the first entry vy ID" do
      expect(CypherRecord.engine).to receive(:query).with("MATCH cypher_record_entity:CypherRecord_Entity WHERE ID(cypher_record_entity) = 1234 RETURN cypher_record_entity LIMIT 1")
      CypherRecord::Entity.find(1234)
    end
  end

  describe ".find_by" do
    let(:query_string) do
      "MATCH dummy_cypher_entity_class:DummyCypherEntityClass {foo: 'Foo'} RETURN dummy_cypher_entity_class LIMIT 1"
    end

    it "creates the query to find the entity" do
      expect(CypherRecord.engine).to receive(:query).with(query_string)
      DummyCypherEntityClass.find_by(foo: "Foo")
    end
  end
end
