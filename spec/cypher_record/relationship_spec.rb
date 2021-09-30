require "spec_helper"

RSpec.describe CypherRecord::Relationship do

  class DummyCypherRecordEdgeClass < CypherRecord::Relationship
    property :one
    property :two
  end

  class CypherRecordEdgeClassWithoutProperties < CypherRecord::Relationship
  end

  subject { DummyCypherRecordEdgeClass.new(variable_name: :n, one: 1, two: "two") }

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

  describe "#token" do
    it "correctly formats the edge" do
      expect(subject.realize).to eq(
        "[n:DummyCypherRecordEdgeClass {one: 1, two: 'two'}]"
      )
    end

    context "when an id is not defined" do
      subject { DummyCypherRecordEdgeClass.new(one: 1, two: "two") }

      it "does not include the variable name in the string" do
        expect(subject.realize).to eq(
          "[:DummyCypherRecordEdgeClass {one: 1, two: 'two'}]"
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
end
