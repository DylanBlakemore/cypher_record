require "spec_helper"

RSpec.describe CypherRecord::Token do

  subject { described_class.new("MERGE", :foo) }

  describe "#to_s" do
    it "combines the operator and operand" do
      expect(subject.realize).to eq("MERGE foo")
    end
  end
end
