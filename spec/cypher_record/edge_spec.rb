require "spec_helper"

RSpec.describe CypherRecord::Edge do

  class DummyCypherRecordEdgeClass < CypherRecord::Edge
    properties :one, :two
  end

  class CypherRecordEdgeClassWithoutProperties < CypherRecord::Edge
  end

  subject { DummyCypherRecordEdgeClass.new(id: :n, one: 1, two: "two") }

  describe ".create" do
    class FooNode < CypherRecord::Node
      properties :foo
    end

    class BarEdge < CypherRecord::Edge
      properties :bar
    end

    let(:left_node) { FooNode.new(id: :foo_1, foo: "Foo 1") }
    let(:right_node) { FooNode.new(id: :foo_2, foo: "Foo 2") }

    it "correctly formats the query" do
      expect(CypherRecord.engine).to receive(:query).with(
        "MATCH (foo_1:FooNode {foo: 'Foo 1'}) MATCH (foo_2:FooNode {foo: 'Foo 2'}) CREATE (foo_1) - [bar_edge:BAR_EDGE {bar: 'Bar'}] -> (foo_2) RETURN bar_edge"
      )
      BarEdge.create(left_node, right_node, bar: "Bar")
    end
  end

  describe "#to_s" do
    it "correctly formats the edge" do
      expect(subject.to_s).to eq(
        "[n:DUMMY_CYPHER_RECORD_EDGE_CLASS {one: 1, two: 'two'}]"
      )
    end

    context "when an id is not defined" do
      subject { DummyCypherRecordEdgeClass.new(one: 1, two: "two") }

      it "does not include the variable name in the string" do
        expect(subject.to_s).to eq(
          "[:DUMMY_CYPHER_RECORD_EDGE_CLASS {one: 1, two: 'two'}]"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecordEdgeClassWithoutProperties.new(id: :n) }

      it "does not include the properties" do
        expect(subject.to_s).to eq(
          "[n:CYPHER_RECORD_EDGE_CLASS_WITHOUT_PROPERTIES]"
        )
      end
    end
  end
end
