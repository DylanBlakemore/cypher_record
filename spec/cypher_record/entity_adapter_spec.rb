require "spec_helper"

RSpec.describe CypherRecord::EntityAdapter do
  describe ".resolve_label" do
    it "replaces _ with ::" do
      expect(described_class.send(:resolve_label, "Namespace_Class")).to eq("Namespace::Class")
    end
  end
end
