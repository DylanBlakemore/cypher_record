require "spec_helper"

RSpec.describe CypherRecord::NodeDefinition do

  subject { described_class.new(:foo_node) }

  describe "#string" do
    context "with just the name defined" do
      it "adds a string property with no default and null: true" do
        subject.string(:string_property)
        property = subject.properties.last
        expect(property.name).to eq(:string_property)
        expect(property.types).to eq([String])
        expect(property.null).to eq(true)
        expect(property.default).to eq(nil)
      end
    end

    context "with additional options" do
      it "assigns the options" do
        subject.string(:string_property, null: false, default: "foo")
        property = subject.properties.last
        expect(property.name).to eq(:string_property)
        expect(property.types).to eq([String])
        expect(property.null).to eq(false)
        expect(property.default).to eq("foo")
      end
    end
  end

  describe "#integer" do
    context "with just the name defined" do
      it "adds a integer property with no default and null: true" do
        subject.integer(:integer_property)
        property = subject.properties.last
        expect(property.name).to eq(:integer_property)
        expect(property.types).to eq([Integer])
        expect(property.null).to eq(true)
        expect(property.default).to eq(nil)
      end
    end

    context "with additional options" do
      it "assigns the options" do
        subject.integer(:integer_property, null: false, default: 1)
        property = subject.properties.last
        expect(property.name).to eq(:integer_property)
        expect(property.types).to eq([Integer])
        expect(property.null).to eq(false)
        expect(property.default).to eq(1)
      end
    end
  end

  describe "#boolean" do
    context "with just the name defined" do
      it "adds a boolean property with no default and null: true" do
        subject.boolean(:boolean_property)
        property = subject.properties.last
        expect(property.name).to eq(:boolean_property)
        expect(property.types).to eq([TrueClass, FalseClass])
        expect(property.null).to eq(true)
        expect(property.default).to eq(nil)
      end
    end

    context "with additional options" do
      it "assigns the options" do
        subject.boolean(:boolean_property, null: false, default: true)
        property = subject.properties.last
        expect(property.name).to eq(:boolean_property)
        expect(property.types).to eq([TrueClass, FalseClass])
        expect(property.null).to eq(false)
        expect(property.default).to eq(true)
      end
    end
  end

  describe "#float" do
    context "with just the name defined" do
      it "adds a float property with no default and null: true" do
        subject.float(:float_property)
        property = subject.properties.last
        expect(property.name).to eq(:float_property)
        expect(property.types).to eq([Float])
        expect(property.null).to eq(true)
        expect(property.default).to eq(nil)
      end
    end

    context "with additional options" do
      it "assigns the options" do
        subject.float(:float_property, null: false, default: 0.0)
        property = subject.properties.last
        expect(property.name).to eq(:float_property)
        expect(property.types).to eq([Float])
        expect(property.null).to eq(false)
        expect(property.default).to eq(0.0)
      end
    end
  end

end
