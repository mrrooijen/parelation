require "spec_helper"

describe Parelation::Criteria::Order do

  let(:klass) { Parelation::Criteria::Order }

  it "should match" do
    expect(klass.match?("order")).to eq(true)
  end

  it "should not match" do
    expect(klass.match?("query")).to eq(false)
  end

  it "should add acending order criteria to the chain" do
    expect(klass.new(Ticket.all, "order", "created_at:asc").call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"   } +
             %Q{ORDER BY "tickets"."created_at" ASC})
  end

  it "should add descending order criteria to the chain" do
    expect(klass.new(Ticket.all, "order", "created_at:desc").call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"   } +
             %Q{ORDER BY "tickets"."created_at" DESC})
  end

  it "should combined multiple asc and desc order criteria" do
    orders = %w[created_at:desc name:asc updated_at:desc message:asc]
    expect(klass.new(Ticket.all, "order", orders).call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"   } +
             %Q{ORDER BY "tickets"."created_at" DESC, } +
             %Q{"tickets"."name" ASC, } +
             %Q{"tickets"."updated_at" DESC, } +
             %Q{"tickets"."message" ASC})
  end
end
