require "spec_helper"

RSpec.describe CypherRecord::Edge do

  class DummyCypherRecordEdgeClass < CypherRecord::Edge
    properties :one, :two
  end

  class CypherRecordEdgeClassWithoutProperties < CypherRecord::Edge
  end

  subject { DummyCypherRecordEdgeClass.new(id: :n, one: 1, two: "two") }

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