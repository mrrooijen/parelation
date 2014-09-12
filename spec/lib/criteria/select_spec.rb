require "spec_helper"

describe Parelation::Criteria::Select do

  let(:klass) { Parelation::Criteria::Select }

  it "should match" do
    expect(klass.match?("select")).to eq(true)
  end

  it "should not match" do
    expect(klass.match?("query")).to eq(false)
  end

  it "should add criteria to the chain" do
    criteria = klass.new(Ticket.all, "select", ["id", "name"]).call
    ar_query = Ticket.all.select(:id, :name)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end
end
