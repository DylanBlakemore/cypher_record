require "spec_helper"

RSpec.describe CypherRecord::Node do

  class DummyCypherRecordNodeClass < CypherRecord::Node
    properties :one, :two
  end

  subject { DummyCypherRecordNodeClass.new(id: :n, one: 1, two: "two") }

  describe "#to_s" do
    it "correctly formats the node" do
      expect(subject.to_s).to eq(
        "(n:DummyCypherRecordNodeClass {one: 1, two: 'two'})"
      )
    end
  end
end
