require "spec_helper"

describe Parelation::Criteria::Query do

  let(:klass) { Parelation::Criteria::Query }

  it "should match" do
    expect(klass.match?("query")).to eq(true)
  end

  it "should not match" do
    expect(klass.match?("not_query")).to eq(false)
  end

  it "should add single-column criteria to the chain" do
    criteria = klass.new(Ticket.all, "query", { "ruby on rails" => "name" }).call
    ar_query = Ticket.where(%Q{"tickets"."name" LIKE ?}, "%ruby on rails%")

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add multi-column criteria to the chain" do
    criteria = klass.new(Ticket.all, "query", { "ruby on rails" => ["name", "message"] }).call
    ar_query = Ticket.where(
      %Q{"tickets"."name" LIKE ? OR "tickets"."message" LIKE ?},
      "%ruby on rails%", "%ruby on rails%"
    )

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end
end
