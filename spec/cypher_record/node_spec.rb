require "spec_helper"

RSpec.describe CypherRecord::Node do

  class DummyCypherRecordNodeClass < CypherRecord::Node
    properties :one, :two
  end

  class CypherRecordNodeClassWithoutProperties < CypherRecord::Node
  end

  subject { DummyCypherRecordNodeClass.new(id: :n, one: 1, two: "two") }

  describe "#to_s" do
    it "correctly formats the node" do
      expect(subject.to_s).to eq(
        "(n:DummyCypherRecordNodeClass {one: 1, two: 'two'})"
      )
    end

    context "when an id is not defined" do
      subject { DummyCypherRecordNodeClass.new(one: 1, two: "two") }

      it "does not include the variable name in the string" do
        expect(subject.to_s).to eq(
          "(:DummyCypherRecordNodeClass {one: 1, two: 'two'})"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecordNodeClassWithoutProperties.new(id: :n) }

      it "does not include the properties" do
        expect(subject.to_s).to eq(
          "(n:CypherRecordNodeClassWithoutProperties)"
        )
      end
    end
  end
end
