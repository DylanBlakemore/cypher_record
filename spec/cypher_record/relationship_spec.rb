require "spec_helper"

RSpec.describe CypherRecord::Relationship do

  class DummyCypherRecordEdgeClass < CypherRecord::Relationship
    property :one
    property :two
  end

  class CypherRecordEdgeClassWithoutProperties < CypherRecord::Relationship
  end

  subject { DummyCypherRecordEdgeClass.new(variable_name: :n, one: 1, two: "two") }

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_relationship")
    end
  end

  describe ".variable_token" do
    it "returns the default variable name" do
      expect(described_class.variable_token).to eq("[cypher_record_relationship]")
    end
  end

  describe ".create" do
    class FooNode < CypherRecord::Node
      property :foo
    end

    class BarEdge < CypherRecord::Relationship
      property :bar
    end

    let(:left_node) { FooNode.new(variable_name: :foo_1, foo: "Foo 1") }
    let(:right_node) { FooNode.new(variable_name: :foo_2, foo: "Foo 2") }

    it "correctly formats the query" do
      expect(CypherRecord.engine).to receive(:query).with(
        "MATCH (foo_1:FooNode {foo: 'Foo 1'}) MATCH (foo_2:FooNode {foo: 'Foo 2'}) CREATE (foo_1) - [bar_edge:BarEdge {bar: 'Bar'}] -> (foo_2) RETURN bar_edge"
      )
      BarEdge.create(left_node, right_node, bar: "Bar")
    end
  end

  describe ".realize" do
    it "correctly formats the node" do
      expect(DummyCypherRecordEdgeClass.realize).to eq(
        "[dummy_cypher_record_edge_class:DummyCypherRecordEdgeClass]"
      )
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(DummyCypherRecordEdgeClass.realize(:variable)).to eq("[dummy_cypher_record_edge_class]")
      end
    end
  end

  describe "#realize" do
    it "correctly formats the edge" do
      expect(subject.realize).to eq(
        "[n:DummyCypherRecordEdgeClass {one: 1, two: 'two'}]"
      )
    end

    context "when a variable name is not defined" do
      subject { DummyCypherRecordEdgeClass.new(one: 1, two: "two") }

      it "uses the defaut" do
        expect(subject.realize).to eq(
          "[dummy_cypher_record_edge_class:DummyCypherRecordEdgeClass {one: 1, two: 'two'}]"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecordEdgeClassWithoutProperties.new(variable_name: :n) }

      it "does not include the properties" do
        expect(subject.realize).to eq(
          "[n:CypherRecordEdgeClassWithoutProperties]"
        )
      end
    end
  end

  describe ".all" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::Relationship.all.realize).to eq("MATCH [cypher_record_relationship:CypherRecord_Relationship]")
    end
  end

  describe ".where" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(DummyCypherRecordEdgeClass.where(foo: "Foo").realize).to eq("MATCH [dummy_cypher_record_edge_class:DummyCypherRecordEdgeClass] WHERE dummy_cypher_record_edge_class.foo = 'Foo'")
    end
  end

  describe ".find" do
    let(:query_string) { "MATCH [dummy_cypher_record_edge_class:DummyCypherRecordEdgeClass] WHERE ID(dummy_cypher_record_edge_class) = 1234 RETURN dummy_cypher_record_edge_class LIMIT 1" }
    let(:relationship) { DummyCypherRecordEdgeClass.new(id: 1234, one: 1, two: "two") }

    it "resolves the query to find the relationship with the matching ID" do
      expect(CypherRecord.engine).to receive(:query).with(query_string).and_return([relationship])
      expect(DummyCypherRecordEdgeClass.find(1234)).to eq(relationship)
    end
  end
end
