require "spec_helper"

RSpec.describe CypherRecord::Engine do

  subject { described_class.new }

  describe "#query" do
    it "raises an exception" do
      expect { subject.query("") }.to raise_error(NotImplementedError, "CypherRecord::Engine must implement a 'query' method")
    end
  end
end
