require "spec_helper"

RSpec.describe CypherRecord::Engines::Neo4jEngine, type: :engine do

  subject { described_class.new(uri, user, password) }

  let(:uri) { "bolt://localhost:7687" }
  let(:password) { "password" }
  let(:user) { "neo4j" }

  it "sets the uri" do
    expect(subject.uri).to eq(uri)
  end

  it "sets the password" do
    expect(subject.password).to eq(password)
  end

  it "sets the username" do
    expect(subject.username).to eq(user)
  end
end
