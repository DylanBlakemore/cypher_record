require "spec_helper"

RSpec.describe CypherRecord::Relationship do

  subject { CypherRecord::RelationshipExample.new(variable_name: :n, foo: 1, bar: "two") }

  describe ".variable_name" do
    it "returns the correct name" do
      expect(described_class.variable_name).to eq("cypher_record_relationship")
    end
  end

  describe ".variable_token" do
    it "returns the default variable name" do
      expect(described_class.variable_token).to eq("[cypher_record_relationship]")
    end
  end

  describe ".create" do
    let(:left_node) { CypherRecord::NodeExample.new(id: 1, variable_name: :n, foo: "Foo 1") }
    let(:right_node) { CypherRecord::NodeExample.new(id: 2, variable_name: :n, foo: "Foo 2") }

    it "correctly formats the query" do
      expect(CypherRecord.engine).to receive(:query).with(
        "MERGE (n_1:CypherRecord_NodeExample {foo: 'Foo 1'}) MERGE (n_2:CypherRecord_NodeExample {foo: 'Foo 2'}) CREATE (n_1)-[cypher_record_relationship_example:CypherRecord_RelationshipExample {bar: 'Bar'}]->(n_2) RETURN cypher_record_relationship_example"
      )
      CypherRecord::RelationshipExample.create(left_node, right_node, bar: "Bar")
    end
  end

  describe ".realize" do
    it "correctly formats the node" do
      expect(CypherRecord::RelationshipExample.realize).to eq(
        "[cypher_record_relationship_example:CypherRecord_RelationshipExample]"
      )
    end

    context "when the variable token is requested" do
      it "correctly formats the node" do
        expect(CypherRecord::RelationshipExample.realize(:variable)).to eq("[cypher_record_relationship_example]")
      end
    end
  end

  describe "#realize" do
    it "correctly formats the edge" do
      expect(subject.realize).to eq(
        "[n:CypherRecord_RelationshipExample {foo: 1, bar: 'two'}]"
      )
    end

    context "when a variable name is not defined" do
      subject { CypherRecord::RelationshipExample.new(foo: 1, bar: "two") }

      it "uses the defaut" do
        expect(subject.realize).to eq(
          "[cypher_record_relationship_example:CypherRecord_RelationshipExample {foo: 1, bar: 'two'}]"
        )
      end
    end

    context "when no properties are defined" do
      subject { CypherRecord::MutualRelationshipExample.new(variable_name: :n) }

      it "does not include the properties" do
        expect(subject.realize).to eq(
          "[n:CypherRecord_MutualRelationshipExample]"
        )
      end
    end
  end

  describe ".all" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::Relationship.all.realize).to eq("MATCH [cypher_record_relationship:CypherRecord_Relationship]")
    end
  end

  describe ".where" do
    it "resolves a query which returns all of the nodes with the correct label" do
      expect(CypherRecord::RelationshipExample.where(foo: "Foo").realize).to eq("MATCH [cypher_record_relationship_example:CypherRecord_RelationshipExample] WHERE cypher_record_relationship_example.foo = 'Foo'")
    end
  end

  describe ".find" do
    let(:query_string) { "MATCH [cypher_record_relationship_example:CypherRecord_RelationshipExample] WHERE ID(cypher_record_relationship_example) = 1234 RETURN cypher_record_relationship_example LIMIT 1" }
    let(:relationship) { CypherRecord::RelationshipExample.new(id: 1234, foo: 1, bar: "two") }

    it "resolves the query to find the relationship with the matching ID" do
      expect(CypherRecord.engine).to receive(:query).with(query_string).and_return([relationship])
      expect(CypherRecord::RelationshipExample.find(1234)).to eq(relationship)
    end
  end

  describe ".find_by" do
    let(:query_string) do
      "MATCH [cypher_record_relationship_example:CypherRecord_RelationshipExample {foo: 'Foo'}] RETURN cypher_record_relationship_example LIMIT 1"
    end

    it "creates the query to find the entity" do
      expect(CypherRecord.engine).to receive(:query).with(query_string)
      CypherRecord::RelationshipExample.find_by(foo: "Foo")
    end
  end
end
