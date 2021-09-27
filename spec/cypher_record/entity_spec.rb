require "spec_helper"

RSpec.describe CypherRecord::Entity do
  
  class DummyCypherEntityClass < CypherRecord::Entity
    properties :foo, :bar
  end

  let(:klass) { DummyCypherEntityClass }

  let(:entity) { klass.new(variable_name: :n, foo: "Foo", bar: 1) }

  it "assigns the correct instance variables" do
    expect(entity.foo).to eq("Foo")
    expect(entity.bar).to eq(1)
  end

  describe "#to_s" do
    it "creates the base string" do
      expect(entity.to_s).to eq("n:DummyCypherEntityClass {foo: 'Foo', bar: 1}")
    end
  end

  describe "#type" do
    it "returns the class name" do
      expect(entity.label).to eq("DummyCypherEntityClass")
    end
  end

  describe "#property_string" do
    let(:property_string) do
      "{foo: 'Foo', bar: 1}"
    end

    it "returns the correctly formatted property string" do
      expect(entity.property_string).to eq(property_string)
    end
  end
end
