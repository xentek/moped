require "spec_helper"

describe Moped::ReadPreference::Primary do

  describe "#select", replica_set: true do

    let(:nodes) do
      @replica_set.nodes
    end

    let(:primary) do
      Moped::Node.new(@primary.address)
    end

    context "when a primary is available" do

      let(:ring) do
        Moped::Ring.new([ primary ])
      end

      before do
        primary.refresh
      end

      let(:node) do
        described_class.select(ring)
      end

      it "returns the primary" do
        expect(node).to eq(primary)
      end
    end

    context "when a primary is not available" do

      let(:ring) do
        Moped::Ring.new([])
      end

      it "raises an error" do
        expect {
          described_class.select(ring)
        }.to raise_error(Moped::ReadPreference::Primary::Unavailable)
      end
    end
  end
end