require "spec_helper"

RSpec.describe CypherRecord::Plugins::Neo4jAdapter do

  let(:keys) { [] }
  let(:values) { [] }
  let(:result) { double(keys: keys, values: values) }
  
  describe ".adapt" do
    context "for single variables" do
      context "when the label does not exist as a class" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Node.new(123, ["MissingNodeClass"], {foo: "Foo", bar: "Bar"})
          ]
        end

        it "raises an appropriate exception" do
          expect { described_class.adapt(result) }.to raise_error(CypherRecord::LabelError, "Model for label MissingNodeClass does not exist")
        end
      end

      context "for a node" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Node.new(123, ["CypherRecord_NodeExample"], {foo: "Foo", bar: "Bar"})
          ]
        end

        it "creates an instance of the required class type" do
          expect(described_class.adapt(result)).to be_a(CypherRecord::NodeExample)
        end

        it "creates the correct properties" do
          expect(described_class.adapt(result).properties).to eq({foo: "Foo", bar: "Bar"})
        end

        it "assigns the correct variable name" do
          expect(described_class.adapt(result).variable_name).to eq(:foo_123)
        end
      end

      context "for a relationship" do
        let(:keys) { [:foo] }
        let(:values) do
          [
            Neo4j::Driver::Types::Relationship.new(123, 1, 2, "CypherRecord_RelationshipExample", {foo: "Foo", bar: "Bar"})
          ]
        end

        it "creates an instance of the required class type" do
          expect(described_class.adapt(result)).to be_a(CypherRecord::RelationshipExample)
        end

        it "creates the correct properties" do
          expect(described_class.adapt(result).properties).to eq({foo: "Foo", bar: "Bar"})
        end

        it "assigns the correct variable name" do
          expect(described_class.adapt(result).variable_name).to eq(:foo_123)
        end
      end

      context "for primitive values" do
        let(:keys) { [:foo] }
        let(:values)  { ["foo"] }

        it "returns the value" do
          expect(described_class.adapt(result)).to eq("foo")
        end
      end
    end

    context "for multiple variables" do
      let(:keys) { [:node_key, :rel_key] }
      let(:values) do
        [
          Neo4j::Driver::Types::Node.new(123, ["CypherRecord_NodeExample"], {foo: "Node foo", bar: "Node bar"}),
          Neo4j::Driver::Types::Relationship.new(456, 1, 2, "CypherRecord_RelationshipExample", {foo: "Rel foo", bar: "Rel bar"})
        ]
      end

      it "returns the correct data types" do
        expect(described_class.adapt(result).map(&:class)).to eq([CypherRecord::NodeExample, CypherRecord::RelationshipExample])
      end

      it "returns the correct properties" do
        expect(described_class.adapt(result).map(&:properties)).to eq([{foo: "Node foo", bar: "Node bar"}, {foo: "Rel foo", bar: "Rel bar"}])
      end

      it "returns the correct variable names" do
        expect(described_class.adapt(result).map(&:variable_name)).to eq([:node_key_123, :rel_key_456])
      end
    end
  end
end
