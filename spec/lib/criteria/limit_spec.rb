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
    criteria = klass.new(Ticket.all, "limit", "40").call
    ar_query = Ticket.limit(40)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end
end
