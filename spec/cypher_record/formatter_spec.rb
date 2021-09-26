require "spec_helper"

RSpec.describe CypherRecord::Formatter do

  describe "#format_property" do
    context "when the property is a string" do
      it "adds quotes to the value" do
        expect(described_class.format_property("foo")).to eq("'foo'")
      end
    end

    context "when the property is not a string" do
      it "returns the string value" do
        expect(described_class.format_property(0.0)).to eq("0.0")
      end
    end
  end
end
