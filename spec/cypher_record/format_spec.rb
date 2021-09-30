require "spec_helper"

RSpec.describe CypherRecord::Format do

  describe ".property" do
    context "when the property is a string" do
      it "adds quotes to the value" do
        expect(described_class.property("foo")).to eq("'foo'")
      end
    end

    context "when the property is not a string" do
      it "returns the string value" do
        expect(described_class.property(0.0)).to eq("0.0")
      end
    end
  end
  
  describe ".property_keys" do
    it "returns a comma-separated string" do
      expect(described_class.property_keys(:n, [:foo, :bar])).to eq("n.foo, n.bar")
    end
  end

  describe ".entity_property" do
    it "returns the correct string" do
      expect(described_class.entity_property(:n, :foo)).to eq("n.foo")
    end
  end

  describe ".property_assignment" do
    it "returns the correct string" do
      expect(described_class.property_assignment(:n, :foo, "Foo 1")).to eq("n.foo = 'Foo 1'")
    end
  end
end
