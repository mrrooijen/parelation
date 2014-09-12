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
    criteria = klass.new(Ticket.all, "order", "created_at:asc").call
    ar_query = Ticket.order(created_at: :asc)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add descending order criteria to the chain" do
    criteria = klass.new(Ticket.all, "order", "created_at:desc").call
    ar_query = Ticket.order(created_at: :desc)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should combine multiple asc and desc order criteria" do
    orders = %w[created_at:desc name:asc updated_at:desc message:asc]
    criteria = klass.new(Ticket.all, "order", orders).call
    ar_query = Ticket.order(created_at: :desc, name: :asc, updated_at: :desc, message: :asc)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end
end
