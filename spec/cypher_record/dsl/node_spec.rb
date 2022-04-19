require "spec_helper"

RSpec.describe CypherRecord::Dsl::Node do

  subject { described_class.new("Foo") }

  describe "#named" do
    it "assigns the name" do
      expect(subject.named("bar").name).to eq("bar")
    end
  end

  let(:properties) { CypherRecord::Dsl::PropertySet.from_hash({ key: "value" }) }

  describe "make" do
    context "with all attributes" do
      subject { described_class.new("Foo", name: "f", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("(f:Foo {key: 'value'})")
      end
    end

    context "with no attributes" do
      subject { described_class.new }

      it "formats the node correctly" do
        expect(subject.make).to eq("()")
      end
    end

    context "without properties" do
      subject { described_class.new("Foo", name: "f") }

      it "formats the node correctly" do
        expect(subject.make).to eq("(f:Foo)")
      end
    end

    context "without a label" do
      subject { described_class.new(name: "f", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("(f {key: 'value'})")
      end
    end

    context "with multiple labels" do
      subject { described_class.new("Foo", "Bar", name: "f", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("(f:Foo:Bar {key: 'value'})")
      end
    end

    context "without a name" do
      subject { described_class.new("Foo", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("(:Foo {key: 'value'})")
      end
    end

    context "with only a name" do
      subject { described_class.new(name: "f") }

      it "formats the node correctly" do
        expect(subject.make).to eq("(f)")
      end
    end

    context "with only labels" do
      subject { described_class.new("Foo") }

      it "formats the node correctly" do
        expect(subject.make).to eq("(:Foo)")
      end
    end

    context "with only properties" do
      subject { described_class.new(properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("({key: 'value'})")
      end
    end
  end

  let(:node_1) { described_class.new("Foo").named("f") }
  let(:node_2) { described_class.new("Bar").named("b") }
  let(:relationship) { CypherRecord::Dsl::Relationship.new(relationship_type, name: "r") }
  let(:relationship_type) { "Rel" }

  describe "#relationship_to" do
    context "without a relationship" do
      subject { node_1.relationship_to(node_2) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[]->(b:Bar)")
      end
    end

    context "with a relationship type" do
      subject { node_1.relationship_to(node_2, relationship_type) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[:Rel]->(b:Bar)")
      end
    end

    context "with a relationship" do
      subject { node_1.relationship_to(node_2, relationship) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[r:Rel]->(b:Bar)")
      end
    end
  end

  describe "#relationship_from" do
    context "without a relationship" do
      subject { node_1.relationship_from(node_2) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)<-[]-(b:Bar)")
      end
    end

    context "with a relationship type" do
      subject { node_1.relationship_from(node_2, relationship_type) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)<-[:Rel]-(b:Bar)")
      end
    end

    context "with a relationship" do
      subject { node_1.relationship_from(node_2, relationship) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)<-[r:Rel]-(b:Bar)")
      end
    end
  end

  describe "#relationship_between" do
    context "without a relationship" do
      subject { node_1.relationship_between(node_2) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[]-(b:Bar)")
      end
    end

    context "with a relationship type" do
      subject { node_1.relationship_between(node_2, relationship_type) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[:Rel]-(b:Bar)")
      end
    end

    context "with a relationship" do
      subject { node_1.relationship_between(node_2, relationship) }

      it "returns the correct pattern" do
        expect(subject.make).to eq("(f:Foo)-[r:Rel]-(b:Bar)")
      end
    end
  end

  describe "relationship chaining" do
    let(:node_3) { described_class.new("FooBar").named("fb") }

    subject do
      node_1.relationship_to(node_2, relationship).relationship_from(node_3, "NewType")
    end

    it "returns the correct pattern" do
      expect(subject.make).to eq("(f:Foo)-[r:Rel]->(b:Bar)<-[:NewType]-(fb:FooBar)")
    end
  end
end
