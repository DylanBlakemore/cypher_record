require "spec_helper"

RSpec.describe CypherRecord::Query do

  let(:node) { CypherRecord::NodeExample.new(variable_name: :n, foo: "foo", bar: "bar") }
  let(:query) { described_class.new }
  let(:base_query) { described_class.new(entity: node) }
  
  describe "#create" do
    let(:query_string) { "CREATE (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'})" }

    it "builds the correct query" do
      expect(query.create(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.create.realize).to eq(query_string)
      end
    end

    context "with return" do
      let(:query_string) { "CREATE (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'}) RETURN n" }

      it "builds the correct query" do
        expect(query.create(node).return(node).realize).to eq("CREATE (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'}) RETURN n")
      end

      context "with a base entity" do
        it "builds the correct query" do
          expect(base_query.create.return.realize).to eq(query_string)
        end
      end
    end
  end

  describe "#match" do
    let(:query_string) { "MATCH (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'})" }

    it "builds the correct query" do
      expect(query.match(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.match.realize).to eq(query_string)
      end
    end
  end

  describe "#merge" do
    let(:query_string) { "MERGE (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'})" }

    it "builds the correct query" do
      expect(query.merge(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.merge.realize).to eq(query_string)
      end
    end
  end

  describe "#destroy" do
    let(:query_string) { "DETACH DELETE n" }

    it "builds the correct query" do
      expect(query.destroy(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.destroy.realize).to eq(query_string)
      end
    end
  end

  describe "#delete" do
    let(:query_string) { "DELETE n" }

    it "builds the correct query" do
      expect(query.delete(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.delete.realize).to eq(query_string)
      end
    end
  end

  describe "#return" do
    let(:query_string) { "RETURN n" }

    it "builds the correct query" do
      expect(query.return(node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.return.realize).to eq(query_string)
      end
    end

    context "with properties" do
      let(:query_string) { "RETURN n.foo, n.bar" }

      it "builds the correct query" do
        expect(base_query.return(properties: [:foo, :bar]).realize).to eq(query_string)
      end
    end
  end

  describe "#set" do
    let(:query_string) { "SET n.foo = 'new_value'" }

    it "builds the correct query" do
      expect(query.set(:foo, "new_value", node).realize).to eq(query_string)
    end

    context "with a base entity" do
      it "builds the correct query" do
        expect(base_query.set(:foo, "new_value").realize).to eq(query_string)
      end
    end
  end

  describe "#resolve" do
    it "uses the engine to resolve the query" do
      expect(CypherRecord.engine).to receive(:query).with("MATCH (n:CypherRecord_NodeExample {foo: 'foo', bar: 'bar'})").and_return nil
      query.match(node).resolve
    end
  end

  describe "#where" do
    let(:query_string) { "WHERE cypher_record_node_example.foo = 'Foo 1' AND cypher_record_node_example.bar = 'Bar 1'" }

    it "builds the correct query" do
      expect(described_class.new(entity: CypherRecord::NodeExample).where(foo: "Foo 1", bar: "Bar 1").realize).to eq(query_string)
    end

    context "with an optional entity" do
      let(:query_string) { "WHERE n.foo = 'Foo 1' AND n.bar = 'Bar 1'" }

      it "builds the correct query" do
        expect(described_class.new.where(node, foo: "Foo 1", bar: "Bar 1").realize).to eq(query_string)
      end
    end
  end

  describe "#limit" do
    it "returns the correct statement" do
      expect(described_class.new.limit(5).realize).to eq("LIMIT 5")
    end
  end
end
