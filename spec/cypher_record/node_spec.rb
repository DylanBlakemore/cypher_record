require "spec_helper"

RSpec.describe CypherRecord::Node do

  subject { CypherRecord::NodeExample.new(variable_name: :n, foo: 1, bar: "two") }

  describe ".relationships" do
    let!(:expected_relationships) do
      {
        child_node_examples: CypherRecord::Path[CypherRecord::RelationshipExample].to(CypherRecord::ChildNodeExample),
        node_examples: CypherRecord::Path[CypherRecord::MutualRelationshipExample].to(CypherRecord::NodeExample)
      }
    end

    it "returns the relationship definitions for the class" do
      expect(CypherRecord::NodeExample.relationships).to eq(expected_relationships)
    end
  end

  describe "relationship queries" do
    let(:parent_node) { CypherRecord::NodeExample.new(id: 123, foo: "Foo", bar: "Bar") }
    let(:query_string) do
      "MATCH (cypher_record_node_example_123:CypherRecord_NodeExample {foo: 'Foo', bar: 'Bar'})"\
      "-[cypher_record_relationship_example:CypherRecord_RelationshipExample]"\
      "->(cypher_record_child_node_example:CypherRecord_ChildNodeExample) "\
      "WHERE ID(cypher_record_node_example_123) = 123"
    end

    let(:return_query_string) do
      query_string.concat(" RETURN cypher_record_child_node_example")
    end

    it "responds to the query keys" do
      expect(parent_node.respond_to?(:child_node_examples)).to eq(true)
      expect(parent_node.respond_to?(:node_examples)).to eq(true)
    end

    it "behaves normally for missing methods" do
      expect { parent_node.undefined_method }.to raise_error(NoMethodError)
    end

    it "creates a query for the related nodes" do
      expect(parent_node.child_node_examples.realize).to eq(query_string)
      expect(parent_node.child_node_examples.return.realize).to eq(return_query_string)
    end
  end

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_node")
    end
  end

  describe ".variable_token" do
    it "returns the default variable name" do
      expect(described_class.variable_token).to eq("(cypher_record_node)")
    end
  end

  describe ".create" do
    it "creates the node with the default variable name" do
      expect(CypherRecord.engine).to receive(:query).with(
        "CREATE (cypher_record_node_example:CypherRecord_NodeExample {foo: 1, bar: 'two'}) RETURN cypher_record_node_example"
      )
      CypherRecord::NodeExample.create(foo: 1, bar: "two")
    end
  end

  describe ".realize" do
    it "correctly formats the node" do
      expect(CypherRecord::NodeExample.realize).to eq(
        "(cypher_record_node_example:CypherRecord_NodeExample)"
      )
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(CypherRecord::NodeExample.realize(:variable)).to eq("(cypher_record_node_example)")
      end
    end
  end

  describe "#realize" do
    it "correctly formats the node" do
      expect(subject.realize).to eq(
        "(n:CypherRecord_NodeExample {foo: 1, bar: 'two'})"
      )
    end

    context "when a variable name is not defined" do
      subject { CypherRecord::NodeExample.new(foo: 1, bar: "two") }

      it "uses the default" do
        expect(subject.realize).to eq(
          "(cypher_record_node_example:CypherRecord_NodeExample {foo: 1, bar: 'two'})"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecord::ChildNodeExample.new(variable_name: :n) }

      it "does not include the properties" do
        expect(subject.realize).to eq(
          "(n:CypherRecord_ChildNodeExample)"
        )
      end
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(subject.realize(:variable)).to eq("(n)")
      end
    end
  end

  describe ".all" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::Node.all.realize).to eq("MATCH (cypher_record_node:CypherRecord_Node)")
    end
  end

  describe ".where" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::NodeExample.where(foo: "Foo").realize).to eq("MATCH (cypher_record_node_example:CypherRecord_NodeExample) WHERE cypher_record_node_example.foo = 'Foo'")
    end
  end

  describe ".find" do
    let(:query_string) { "MATCH (cypher_record_node_example:CypherRecord_NodeExample) WHERE ID(cypher_record_node_example) = 1234 RETURN cypher_record_node_example LIMIT 1" }
    let(:node) { CypherRecord::NodeExample.new(id: 1234, one: 1, two: "two") }

    it "resolves the query to find the node with the matching ID" do
      expect(CypherRecord.engine).to receive(:query).with(query_string).and_return([node])
      expect(CypherRecord::NodeExample.find(1234)).to eq(node)
    end
  end

  describe ".find_by" do
    let(:query_string) do
      "MATCH (cypher_record_node_example:CypherRecord_NodeExample {foo: 'Foo'}) RETURN cypher_record_node_example LIMIT 1"
    end

    it "creates the query to find the entity" do
      expect(CypherRecord.engine).to receive(:query).with(query_string)
      CypherRecord::NodeExample.find_by(foo: "Foo")
    end
  end

  describe ".find_or_create" do
    let(:query_string) do
      "MERGE (cypher_record_node_example:CypherRecord_NodeExample {foo: 1, bar: 'two'}) RETURN cypher_record_node_example"
    end

    it "creates a query to find or create the node" do
      expect(CypherRecord.engine).to receive(:query).with(query_string)
      CypherRecord::NodeExample.find_or_create(foo: 1, bar: "two")
    end
  end

  describe "#add_relation" do
    let(:query_string) do
      "MERGE (cypher_record_node_example_123:CypherRecord_NodeExample {foo: 'Foo', bar: 'Bar'}) "\
      "MERGE (cypher_record_node_example_456:CypherRecord_NodeExample {foo: 'Foo 2', bar: 'Bar 2'}) "\
      "MERGE (cypher_record_node_example_123)-[cypher_record_mutual_relationship_example:CypherRecord_MutualRelationshipExample]->(cypher_record_node_example_456) "\
      "RETURN cypher_record_mutual_relationship_example"
    end

    let(:parent_node) { CypherRecord::NodeExample.new(id: 123, foo: "Foo", bar: "Bar") }
    let(:child_node) { CypherRecord::NodeExample.new(id: 456, foo: "Foo 2", bar: "Bar 2") }

    it "creates the query needed to relate to another node" do
      expect(CypherRecord.engine).to receive(:query).with(query_string)
      parent_node.add_relation(:node_example, child_node)
    end

    context "when the child class does not match the expected class in the relationship" do
      let(:child_node) { CypherRecord::ChildNodeExample.new }

      it "raises an exception" do
        expect { parent_node.add_relation(:node_example, child_node) }.to raise_error(ArgumentError, "Related node is not a CypherRecord::NodeExample")
      end
    end
  end
end
