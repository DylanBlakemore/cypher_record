require "spec_helper"

RSpec.describe CypherRecord::Dsl::PropertySet do

  subject { described_class.from_hash({ foo: 1, bar: 2 }) }

  describe ".from_hash" do
    it "builds the properties" do
      expect(subject.properties.map(&:key).sort).to eq([:bar, :foo])
    end
  end

  describe "#make" do
    it "formats the properties correctly" do
      expect(subject.make).to eq("{foo: 1, bar: 2}")
    end
  end

  describe "#[]" do
    it "returns the property value" do
      expect(subject[:foo]).to eq(1)
    end
  end

end
