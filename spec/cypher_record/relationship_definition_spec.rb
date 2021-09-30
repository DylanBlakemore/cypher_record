require "spec_helper"

RSpec.describe CypherRecord::RelationshipDefinition do

  subject { described_class.new(parent, relation, child) }

  let(:parent) { double(:parent) }
  let(:child) { double(:child) }
  let(:relation) { double(:relation) }

  describe "init" do
    it "creates the object" do
      expect(subject).to be_a(CypherRecord::RelationshipDefinition)
    end

    it "assigns the values" do
      expect(subject.parent).to eq(parent)
      expect(subject.child).to eq(child)
      expect(subject.relation).to eq(relation)
    end
  end

  describe "equals" do
    context "when the parent, child, and relation are equal" do
      it "returns true" do
        expect(subject == described_class.new(parent, relation, child)).to eq(true)
      end
    end

    context  "when one of the attributes is different" do
      it "returns false" do
        expect(subject == described_class.new(parent, relation, double(:different_child))).to eq(false)
      end
    end

    context "when the other class is different" do
      it "returns false" do
        expect(subject == "hello").to eq(false)
      end
    end
  end
end
