require "spec_helper"

RSpec.describe CypherRecord::Adapters::Neo4jAdapter do

  let(:keys) { [] }
  let(:values) { [] }
  let(:result) { double(keys: keys, values: values) }

  before do
    module NamespacedNode
      class Neo4jNodeClass < CypherRecord::Node
        properties :foo, :bar
      end
    end

    class Neo4jNodeClass < CypherRecord::Node
      properties :foo, :bar
    end

    class Neo4jRelationshipClass < CypherRecord::Relationship
      properties :foo, :bar
    end
  end
  
  describe ".adapt" do
    context "for single variables" do
      context "when the label does not exist as a class" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Node.new(:foo, ["MissingNodeClass"], {foo: "Foo", bar: "Bar"})
          ]
        end

        it "raises an appropriate exception" do
          expect { described_class.adapt(result) }.to raise_error(CypherRecord::LabelError, "Model for label MissingNodeClass does not exist")
        end
      end

      context "when a namespaced entity is used" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Node.new(:foo, ["NamespacedNode_Neo4jNodeClass"], {foo: "Foo", bar: "Bar"})
          ]
        end

        it "creates an instance of the required class type" do
          expect(described_class.adapt(result).first).to be_a(NamespacedNode::Neo4jNodeClass)
        end
      end

      context "for a node" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Node.new(:foo, ["Neo4jNodeClass"], {foo: "Foo", bar: "Bar"})
          ]
        end

        it "creates an instance of the required class type" do
          expect(described_class.adapt(result).first).to be_a(Neo4jNodeClass)
        end

        it "creates the correct properties" do
          expect(described_class.adapt(result).first.properties).to eq({foo: "Foo", bar: "Bar"})
        end

        it "assigns the correct variable name" do
          expect(described_class.adapt(result).first.variable_name).to eq(:foo)
        end
      end

      context "for a relationship" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Relationship.new(:foo, 1, 2, "Neo4jRelationshipClass", {foo: "Foo", bar: "Bar"})
          ]
        end

        it "creates an instance of the required class type" do
          expect(described_class.adapt(result).first).to be_a(Neo4jRelationshipClass)
        end

        it "creates the correct properties" do
          expect(described_class.adapt(result).first.properties).to eq({foo: "Foo", bar: "Bar"})
        end

        it "assigns the correct variable name" do
          expect(described_class.adapt(result).first.variable_name).to eq(:foo)
        end
      end

      context "for primitive values" do
        let(:keys) { [:foo] }
        let(:values)  { ["foo"] }

        it "returns the value" do
          expect(described_class.adapt(result).first).to eq("foo")
        end
      end
    end

    context "for multiple variables" do
      let(:keys) { [:node_key, :rel_key] }
      let(:values) do
        [
          Neo4j::Driver::Types::Node.new(:foo, ["Neo4jNodeClass"], {foo: "Node foo", bar: "Node bar"}),
          Neo4j::Driver::Types::Relationship.new(:bar, 1, 2, "Neo4jRelationshipClass", {foo: "Rel foo", bar: "Rel bar"})
        ]
      end

      it "returns the correct data types" do
        expect(described_class.adapt(result).map(&:class)).to eq([Neo4jNodeClass, Neo4jRelationshipClass])
      end

      it "returns the correct properties" do
        expect(described_class.adapt(result).map(&:properties)).to eq([{foo: "Node foo", bar: "Node bar"}, {foo: "Rel foo", bar: "Rel bar"}])
      end

      it "returns the correct variable names" do
        expect(described_class.adapt(result).map(&:variable_name)).to eq([:node_key, :rel_key])
      end
    end
  end
end
