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
    criteria = klass.new(Ticket.all, "offset", "40").call
    ar_query = Ticket.offset(40)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end
end
