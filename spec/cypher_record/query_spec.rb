require "spec_helper"

RSpec.describe CypherRecord::Query do

  let(:node) { CypherRecord::Dsl::Node.new("Foo", name: "f", properties: { size: 5 }) }
  let(:node_2) { CypherRecord::Dsl::Node.new("Bar", name: "b") }
  let(:pattern) { node.relationship_to(node_2, "Rel") }
  let(:query) { described_class.new }

  describe "#match" do
    it "returns the correct query for a node" do
      expect(query.match(node).make).to eq("MATCH (f:Foo {size: 5})")
    end

    it "returns the correct query for a string" do
      expect(query.match("(f:Foo)").make).to eq("MATCH (f:Foo)")
    end

    it "returns the correct query for a pattern" do
      expect(query.match(pattern).make).to eq("MATCH (f:Foo {size: 5})-[:Rel]->(b:Bar)")
    end
  end

  describe "#return" do
    it "returns the correct query for a node" do
      expect(query.return(node).make).to eq("RETURN f")
    end

    it "returns multiple values" do
      expect(query.return(node, node.property(:size), "b").make).to eq("RETURN f, f.size, b")
    end
  end

  describe "#create" do
    it "returns the correct query for a node" do
      expect(query.create(node).make).to eq("CREATE (f:Foo {size: 5})")
    end

    it "returns the correct query for a string" do
      expect(query.create("(f:Foo)").make).to eq("CREATE (f:Foo)")
    end

    it "returns the correct query for a pattern" do
      expect(query.create(pattern).make).to eq("CREATE (f:Foo {size: 5})-[:Rel]->(b:Bar)")
    end
  end

  describe "#merge" do
    it "returns the correct query for a node" do
      expect(query.merge(node).make).to eq("MERGE (f:Foo {size: 5})")
    end

    it "returns the correct query for a string" do
      expect(query.merge("(f:Foo)").make).to eq("MERGE (f:Foo)")
    end

    it "returns the correct query for a pattern" do
      expect(query.merge(pattern).make).to eq("MERGE (f:Foo {size: 5})-[:Rel]->(b:Bar)")
    end
  end

  describe "chains" do
    it "match with return" do
      expect(query.match(node).return(node).make).to eq("MATCH (f:Foo {size: 5}) RETURN f")
    end
  end

end
