require "spec_helper"

RSpec.describe CypherRecord::Node do

  class DummyCypherRecordRelationshipClass < CypherRecord::Relationship; end

  class DummyCypherRecordNodeClass < CypherRecord::Node
    property :one
    property :two
  end

  class CypherRecordNodeClassWithoutProperties < CypherRecord::Node
  end

  subject { DummyCypherRecordNodeClass.new(variable_name: :n, one: 1, two: "two") }

  describe ".relationships" do
    let!(:expected_relationships) do
      {
        child_node_examples: CypherRecord::RelationshipDefinition.new(CypherRecord::NodeExample, CypherRecord::RelationshipExample, CypherRecord::ChildNodeExample),
        node_examples: CypherRecord::RelationshipDefinition.new(CypherRecord::NodeExample, CypherRecord::MutualRelationshipExample, CypherRecord::NodeExample)
      }
    end

    it "returns the relationsip definitions for the class" do
      expect(CypherRecord::NodeExample.relationships).to eq(expected_relationships)
    end
  end

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_node")
    end
  end

  describe ".variable_token" do
    it "returns the default variable name" do
      expect(described_class.variable_token).to eq("(cypher_record_node)")
    end
  end

  describe ".create" do
    it "creates the node with the default variable name" do
      expect(CypherRecord.engine).to receive(:query).with(
        "CREATE (dummy_cypher_record_node_class:DummyCypherRecordNodeClass {one: 1, two: 'two'}) RETURN dummy_cypher_record_node_class"
      )
      DummyCypherRecordNodeClass.create(one: 1, two: "two")
    end
  end

  describe ".realize" do
    it "correctly formats the node" do
      expect(DummyCypherRecordNodeClass.realize).to eq(
        "(dummy_cypher_record_node_class:DummyCypherRecordNodeClass)"
      )
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(DummyCypherRecordNodeClass.realize(:variable)).to eq("(dummy_cypher_record_node_class)")
      end
    end
  end

  describe "#realize" do
    it "correctly formats the node" do
      expect(subject.realize).to eq(
        "(n:DummyCypherRecordNodeClass {one: 1, two: 'two'})"
      )
    end

    context "when an id is not defined" do
      subject { DummyCypherRecordNodeClass.new(one: 1, two: "two") }

      it "does not include the variable name in the string" do
        expect(subject.realize).to eq(
          "(:DummyCypherRecordNodeClass {one: 1, two: 'two'})"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecordNodeClassWithoutProperties.new(variable_name: :n) }

      it "does not include the properties" do
        expect(subject.realize).to eq(
          "(n:CypherRecordNodeClassWithoutProperties)"
        )
      end
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(subject.realize(:variable)).to eq("(n)")
      end
    end
  end

  describe ".all" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::Node.all.realize).to eq("MATCH (cypher_record_node:CypherRecord_Node)")
    end
  end

  describe ".where" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(DummyCypherRecordNodeClass.where(foo: "Foo").realize).to eq("WHERE dummy_cypher_record_node_class.foo = 'Foo'")
    end
  end
end
