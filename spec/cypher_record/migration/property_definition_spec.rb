require "spec_helper"

RSpec.describe CypherRecord::PropertyDefinition do

  subject { described_class.new(name, type, null, default) }

  let(:name) { :foo_name }
  let(:type) { String }
  let(:null) { true }
  let(:default) { "Foo" }

  describe "#initialize" do
    context "when the default is nil" do
      let(:default) { nil }

      it "creates the object" do
        expect { subject }.not_to raise_error
      end
    end

    context "when the default is not of the correct type" do
      let(:default) { 0.0 }

      it "raises an appropriate exception" do
        expect { subject }.to raise_error(ArgumentError, "Invalid default 0.0 supplied for property 'foo_name', expected String")
      end
    end
  end

  describe "#name" do
    it "returns the name" do
      expect(subject.name).to eq(:foo_name)
    end
  end

  describe "#type" do
    it "returns the data type" do
      expect(subject.type).to eq(String)
    end
  end

  describe "#null" do
    it "returns whether the property can be null" do
      expect(subject.null).to eq(true)
    end
  end

  describe "#default" do
    it "returns the default" do
      expect(subject.default).to eq("Foo")
    end
  end
end
