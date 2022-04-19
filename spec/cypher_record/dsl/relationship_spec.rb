require "spec_helper"

RSpec.describe CypherRecord::Dsl::Relationship do

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
        expect(subject.make).to eq("[f:Foo {key: 'value'}]")
      end
    end

    context "with no attributes" do
      subject { described_class.new }

      it "formats the node correctly" do
        expect(subject.make).to eq("[]")
      end
    end

    context "without properties" do
      subject { described_class.new("Foo", name: "f") }

      it "formats the node correctly" do
        expect(subject.make).to eq("[f:Foo]")
      end
    end

    context "without a label" do
      subject { described_class.new(name: "f", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("[f {key: 'value'}]")
      end
    end

    context "with multiple labels" do
      subject { described_class.new("Foo", "Bar", name: "f", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("[f:Foo:Bar {key: 'value'}]")
      end
    end

    context "without a name" do
      subject { described_class.new("Foo", properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("[:Foo {key: 'value'}]")
      end
    end

    context "with only a name" do
      subject { described_class.new(name: "f") }

      it "formats the node correctly" do
        expect(subject.make).to eq("[f]")
      end
    end

    context "with only labels" do
      subject { described_class.new("Foo") }

      it "formats the node correctly" do
        expect(subject.make).to eq("[:Foo]")
      end
    end

    context "with only properties" do
      subject { described_class.new(properties: properties) }

      it "formats the node correctly" do
        expect(subject.make).to eq("[{key: 'value'}]")
      end
    end
  end
end
