require "spec_helper"

RSpec.describe CypherRecord::Node do

  class DummyCypherRecordNodeClass < CypherRecord::Node
    property :one
    property :two
  end

  class CypherRecordNodeClassWithoutProperties < CypherRecord::Node
  end

  subject { DummyCypherRecordNodeClass.new(variable_name: :n, one: 1, two: "two") }

  describe ".create" do
    it "creates the node with the default variable name" do
      expect(CypherRecord.engine).to receive(:query).with(
        "CREATE (dummy_cypher_record_node_class:DummyCypherRecordNodeClass {one: 1, two: 'two'}) RETURN dummy_cypher_record_node_class"
      )
      DummyCypherRecordNodeClass.create(one: 1, two: "two")
    end
  end

  describe "#token" do
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
end
