require "spec_helper"

RSpec.describe CypherRecord::Pattern do
  
  subject { described_class.new(left, edge, right) }

  class RelationshipDummyNodeClass < CypherRecord::Node
    properties :foo, :bar
  end

  class RelationshipDummyEdgeClass < CypherRecord::Relationship
    properties :foobar
  end

  let(:left) { RelationshipDummyNodeClass.new(id: :n, foo: "foo_1", bar: "bar_1") }
  let(:right) { RelationshipDummyNodeClass.new(id: :m, foo: "foo_2", bar: "bar_2") }

  let(:edge) { RelationshipDummyEdgeClass.new(id: :e, foobar: "Foobar") }

  describe "#edge_only" do
    it "uses the IDs from the nodes" do
      expect(subject.edge_only.to_s).to eq("(n) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m)")
    end
  end

  describe "#to_s" do
    it "returns the correct string" do
      expect(subject.to_s).to eq(
        "(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})"
      )
    end

    context "when the left node is nil" do
      let(:left) { nil }

      it "returns the correct string" do
        expect(subject.to_s).to eq(
          "() - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})"
        )
      end
    end

    context "when the right node is nil" do
      let(:right) { nil }

      it "returns the correct string" do
        expect(subject.to_s).to eq(
          "(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - ()"
        )
      end
    end

    context "when the direction is forwards" do
      subject { described_class.new(left, edge, right, :forwards) }

      it "returns the correct string" do
        expect(subject.to_s).to eq(
          "(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] -> (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})"
        )
      end
    end

    context "when the direction is backwards" do
      subject { described_class.new(left, edge, right, :backwards) }

      it "returns the correct string" do
        expect(subject.to_s).to eq(
          "(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) <- [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})"
        )
      end
    end

    context "when the direction is invalid" do
      subject { described_class.new(left, edge, right, :foo) }

      it "raise an exception" do
        expect { subject }.to raise_error(ArgumentError, "Relationship direction can only be forwards, backwards, or mutual")
      end
    end
  end
end
