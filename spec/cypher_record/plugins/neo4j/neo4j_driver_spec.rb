require "spec_helper"

RSpec.describe CypherRecord::Plugins::Neo4jDriver, type: :neo4j do

  before do
    class MockNodeClass < CypherRecord::Node
      property :foo
      property :bar
    end
  end

  subject { described_class.new(uri, user, password) }

  let(:uri) { "bolt://localhost:7687" }
  let(:password) { "password" }
  let(:user) { "neo4j" }

  xit "sets the uri" do
    expect(subject.uri).to eq(uri)
  end

  xit "sets the password" do
    expect(subject.password).to eq(password)
  end

  xit "sets the username" do
    expect(subject.username).to eq(user)
  end

  xdescribe "#query" do
    before do
      subject.query("CREATE (mock_node_class:MockNodeClass {foo: 'Foo 1', bar: 'Bar 1'})")
      subject.query("CREATE (mock_node_class:MockNodeClass {foo: 'Foo 2', bar: 'Bar 2'})")
      subject.query("CREATE (mock_node_class:MockNodeClass {foo: 'Foo 3', bar: 'Bar 3'})")
    end

    let(:query_result) { subject.query(query) }

    context "for single returns" do
      let(:query) { "MATCH (n:MockNodeClass) RETURN n" }

      it "returns an array" do
        expect(query_result.size).to eq(3)
        expect(query_result.map(&:class)).to eq([MockNodeClass, MockNodeClass, MockNodeClass])
      end
    end

    context "for multiple returns" do
      let(:query) { "MATCH (n:MockNodeClass) RETURN n.foo, n.bar" }

      it "returns an array of arrays" do
        expect(query_result.sort).to eq([["Foo 1", "Bar 1"], ["Foo 2", "Bar 2"], ["Foo 3", "Bar 3"]])
      end
    end
  end
end
