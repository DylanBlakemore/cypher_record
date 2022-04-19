require "spec_helper"

RSpec.describe CypherRecord::Dsl::Pattern do

  describe "#from_string" do
    let(:pattern) { "(f:Foo)-[r:Rel]->(b:Bar)<-[:NewType]-(fb:FooBar)" }

    it "returns a pattern object" do
      expect(described_class.from_string(pattern).make).to eq(pattern)
    end
  end

end
