require "spec_helper"

RSpec.describe CypherRecord::Dsl::Property do

  subject { described_class.new(key, value) }
  let(:key) { :foo }

  describe "#make" do
    context "for a non-string value" do
      let(:value) { 5 }

      it "formats the string correctly" do
        expect(subject.make).to eq("foo: 5")
      end
    end

    context "for a string value" do
      let(:value) { "bar" }

      it "formats the string correctly" do
        expect(subject.make).to eq("foo: 'bar'")
      end
    end
  end

end
