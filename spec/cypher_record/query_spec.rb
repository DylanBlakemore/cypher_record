require "spec_helper"

RSpec.describe CypherRecord::Query do

  class QueryDummyNodeClass < CypherRecord::Node
    properties :foo, :bar
  end

  let(:node) { QueryDummyNodeClass.new(id: :n, foo: "foo", bar: "bar") }
  let(:query) { described_class.new }
  
  describe "#create" do
    it "builds the correct query" do
      expect(query.create(node).to_s).to eq("CREATE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end

    context "with return" do
      it "builds the correct query" do
        expect(query.create(node).return(node).to_s).to eq("CREATE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'}) RETURN n")
      end
    end
  end

  describe "#match" do
    it "builds the correct query" do
      expect(query.match(node).to_s).to eq("MATCH (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end
  end

  describe "#merge" do
    it "builds the correct query" do
      expect(query.merge(node).to_s).to eq("MERGE (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})")
    end
  end

  describe "#destroy" do
    it "builds the correct query" do
      expect(query.destroy(node).to_s).to eq("DETACH DELETE n")
    end
  end

  describe "#delete" do
    it "builds the correct query" do
      expect(query.delete(node).to_s).to eq("DELETE n")
    end
  end

  describe "#return" do
    it "builds the correct query" do
      expect(query.return(node).to_s).to eq("RETURN n")
    end
  end

  describe "#set" do
    it "builds the correct query" do
      expect(query.set(node, :foo, "new_value").to_s).to eq("SET n.foo = 'new_value'")
    end
  end

  describe "#resolve" do
    it "uses the engine to resolve the query" do
      engine = CypherRecord::Engine.new
      CypherRecord.configure { |config| config.engine = engine }
      expect(engine).to receive(:query).with("MATCH (n:QueryDummyNodeClass {foo: 'foo', bar: 'bar'})").and_return nil
      query.match(node).resolve
    end
  end
end
