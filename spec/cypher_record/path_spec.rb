require "spec_helper"

RSpec.describe CypherRecord::Path do
  
  subject { described_class.from_node(initial, as: initial_type) }

  class RelationshipDummyNodeClass < CypherRecord::Node
    properties :foo, :bar
  end

  class RelationshipDummyEdgeClass < CypherRecord::Relationship
    properties :foobar
  end

  let(:initial_type) { :entity }
  let(:initial) { left }
  let(:left) { RelationshipDummyNodeClass.new(variable_name: :n, foo: "foo_1", bar: "bar_1") }
  let(:right) { RelationshipDummyNodeClass.new(variable_name: :m, foo: "foo_2", bar: "bar_2") }
  let(:edge) { RelationshipDummyEdgeClass.new(variable_name: :e, foobar: "Foobar") }

  describe "chain" do
    let(:other_edge) { RelationshipDummyEdgeClass.new(variable_name: :f, foobar: "Foobar") }
    let(:far_right) { RelationshipDummyNodeClass.new(variable_name: :o, foo: "foo_2", bar: "bar_2") }
    let(:initial_type) { :variable }

    let(:result) do
      subject.has_variable(right, via: edge, as: :variable)
        .belongs_to_variable(far_right, via: other_edge, as: :variable)
        .realize
    end

    it "returns the correct string" do
      expect(result).to eq("(n) - [e] -> (m) <- [f] - (o)")
    end
  end

  describe "#related_to_variable" do
    let(:initial_type) { :variable }
    it "returns the correct string" do
      expect(subject.related_to_variable(right, via: edge).realize).to eq("(n) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m)")
    end
  end

  describe "#related_to_node" do
    it "returns the correct string" do
      expect(subject.related_to_node(right, via: edge).realize).to eq("(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})")
    end
  end

  describe "#has_variable" do
    let(:initial_type) { :variable }
    it "returns the correct string" do
      expect(subject.has_variable(right, via: edge).realize).to eq("(n) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] -> (m)")
    end
  end

  describe "#has_node" do
    it "returns the correct string" do
      expect(subject.has_node(right, via: edge).realize).to eq("(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) - [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] -> (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})")
    end
  end

  describe "#belongs_to_variable" do
    let(:initial_type) { :variable }
    it "returns the correct string" do
      expect(subject.belongs_to_variable(right, via: edge).realize).to eq("(n) <- [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m)")
    end
  end

  describe "#belongs_to_node" do
    it "returns the correct string" do
      expect(subject.belongs_to_node(right, via: edge).realize).to eq("(n:RelationshipDummyNodeClass {foo: 'foo_1', bar: 'bar_1'}) <- [e:RelationshipDummyEdgeClass {foobar: 'Foobar'}] - (m:RelationshipDummyNodeClass {foo: 'foo_2', bar: 'bar_2'})")
    end
  end
end
