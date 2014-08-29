require "spec_helper"

describe Parelation::Criteria::Offset do

  let(:klass) { Parelation::Criteria::Offset }

  it "should match" do
    expect(klass.match?("offset")).to eq(true)
  end

  it "should not match" do
    expect(klass.match?("query")).to eq(false)
  end

  it "should add criteria to the chain" do
    expect(klass.new(Ticket.all, "offset", "80").call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"  LIMIT -1 OFFSET 80})
  end
end
