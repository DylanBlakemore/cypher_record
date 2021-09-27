require "spec_helper"

RSpec.describe CypherRecord::Query do

  class QueryDummyNodeClass < CypherRecord::Node
    properties :foo, :bar
  end

  let(:node) { QueryDummyNodeClass.new(id: :n, foo: "foo", bar: "bar") }
  let(:query) { described_class.new }
  
  describe "#create" do
    it "builds the correct query" do
      expect(query.create(node).resolve).to eq("CREATE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end

    context "with return" do
      it "builds the correct query" do
        expect(query.create(node).return(node).resolve).to eq("CREATE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'}) RETURN n")
      end
    end
  end

  describe "#match" do
    it "builds the correct query" do
      expect(query.match(node).resolve).to eq("MATCH (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end
  end

  describe "#merge" do
    it "builds the correct query" do
      expect(query.merge(node).resolve).to eq("MERGE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end
  end

  describe "#destroy" do
    it "builds the correct query" do
      expect(query.destroy(node).resolve).to eq("DETACH DELETE n")
    end
  end

  describe "#delete" do
    it "builds the correct query" do
      expect(query.delete(node).resolve).to eq("DELETE n")
    end
  end

  describe "#return" do
    it "builds the correct query" do
      expect(query.return(node).resolve).to eq("RETURN n")
    end
  end

  describe "#set" do
    it "builds the correct query" do
      expect(query.set(node, :foo, "new_value").resolve).to eq("SET n.foo = 'new_value'")
    end
  end
end
