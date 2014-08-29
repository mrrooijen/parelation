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
    expect(klass.new(Ticket.all, "select", ["id", "name"]).call.to_sql)
      .to eq(%Q{SELECT "tickets"."id", "tickets"."name" FROM "tickets"})
  end
end
