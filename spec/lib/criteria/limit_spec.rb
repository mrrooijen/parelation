require "spec_helper"

describe Parelation::Criteria::Limit do

  let(:klass) { Parelation::Criteria::Limit }

  it "should match" do
    expect(klass.match?("limit")).to eq(true)
  end

  it "should not match" do
    expect(klass.match?("query")).to eq(false)
  end

  it "should add criteria to the chain" do
    expect(klass.new(Ticket.all, "limit", "40").call.to_sql)
      .to eq(%Q{SELECT  "tickets".* FROM "tickets"  LIMIT 40})
  end
end
