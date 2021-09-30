require "spec_helper"

RSpec.describe CypherRecord::Entity do
  
  class DummyCypherEntityClass < CypherRecord::Entity
    property :foo
    property :bar
  end

  let(:klass) { DummyCypherEntityClass }

  let(:entity) { klass.new(variable_name: :n, foo: "Foo", bar: 1) }

  it "assigns the correct instance variables" do
    expect(entity.foo).to eq("Foo")
    expect(entity.bar).to eq(1)
  end

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_entity")
    end
  end

  describe "#label" do
    it "returns the class name" do
      expect(entity.label).to eq("DummyCypherEntityClass")
    end

    context "with a namespaced class" do
      module Namespaced
        class DummyCypherEntityClass < CypherRecord::Entity
          property :foo
          property :bar
        end
      end

      let(:klass) { Namespaced::DummyCypherEntityClass }

      it "replaces :: with _" do
        expect(entity.label).to eq("Namespaced_DummyCypherEntityClass")
      end
    end
  end
end
