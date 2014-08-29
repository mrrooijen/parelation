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
    value = { "ruby on rails" => "name" }
    expect(klass.new(Ticket.all, "query", value).call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
             %Q{WHERE ("tickets"."name" LIKE '%ruby on rails%')})
  end

  it "should add multi-column criteria to the chain" do
    value = { "ruby on rails" => ["name", "message"] }
    expect(klass.new(Ticket.all, "query", value).call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
             %Q{WHERE ("tickets"."name" LIKE '%ruby on rails%' } +
             %Q{OR "tickets"."message" LIKE '%ruby on rails%')})
  end
end
