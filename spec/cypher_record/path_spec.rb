require "spec_helper"

RSpec.describe CypherRecord::Path do
  
  subject { described_class[CypherRecord::RelationshipExample] }

  describe ".[]" do
    it "returns an instance with the correct relationship" do
      expect(subject.relationship).to eq(CypherRecord::RelationshipExample)
    end
  end

  describe "#from" do
    it "sets the parent node" do
      expect(subject.from(CypherRecord::NodeExample).parent).to eq(CypherRecord::NodeExample)
    end

    context "as variable" do
      it "sets the variable" do
        expect(subject.from(CypherRecord::NodeExample, as: :variable).parent).to eq("(cypher_record_node_example)")
      end
    end
  end

  describe "#to" do
    it "sets the child node" do
      expect(subject.to(CypherRecord::ChildNodeExample).child).to eq(CypherRecord::ChildNodeExample)
    end

    context "as variable" do
      it "sets the variable" do
        expect(subject.to(CypherRecord::ChildNodeExample, as: :variable).child).to eq("(cypher_record_child_node_example)")
      end
    end
  end

  describe "#chained" do
    let(:query_string) { "(cypher_record_node_example)-[cypher_record_relationship_example:CypherRecord_RelationshipExample]->(cypher_record_child_node_example)" }
    it "returns the correct string" do
      expect(subject.from(CypherRecord::NodeExample, as: :variable).to(CypherRecord::ChildNodeExample, as: :variable).realize).to eq(query_string)
    end
  end

end
