require "spec_helper"

RSpec.describe CypherRecord::Driver do

  subject { described_class.new }

  describe "#query" do
    it "raises an exception" do
      expect { subject.query("") }.to raise_error(NotImplementedError, "CypherRecord::Driver must implement a 'query' method")
    end
  end
end
