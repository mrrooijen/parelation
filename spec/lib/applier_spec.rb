require "spec_helper"

describe Parelation::Applier do

  let(:klass) { Parelation::Applier }

  it "should apply the requested criteria" do
    params = {
      "format" => :json,
      "action" => "index",
      "controller" => "api/v1/tickets",
      "select" => ["id", "name", "state", "message"],
      "where" => { state: ["open", "pending"] },
      "where_not" => { state: "closed" },
      "where_gt" => { created_at: "2014-01-01T00:00:00Z" },
      "where_gte" => { updated_at: "2014-01-01T00:00:00Z" },
      "where_lt" => { created_at: "2014-01-01T01:00:00Z" },
      "where_lte" => { updated_at: "2014-01-01T01:00:00Z" },
      "query" => { "ruby on rails" => ["name", "message"] },
      "order" => ["created_at:desc", "name:asc"],
      "limit" => "50",
      "offset" => "100"
    }

    project = Project.create
    criteria = klass.new(project.tickets, params).apply
    ar_query = project.tickets
      .select(:id, :name, :state, :message)
      .where(state: ["open", "pending"])
      .where.not(state: "closed")
      .where(%Q{"tickets".'created_at' > ?}, "2014-01-01 00:00:00.000000")
      .where(%Q{"tickets".'updated_at' >= ?}, "2014-01-01 00:00:00.000000")
      .where(%Q{"tickets".'created_at' < ?}, "2014-01-01 01:00:00.000000")
      .where(%Q{"tickets".'updated_at' <= ?}, "2014-01-01 01:00:00.000000")
      .where(
         %Q{"tickets"."name" LIKE ? OR "tickets"."message" LIKE ?},
         "%ruby on rails%", "%ruby on rails%"
      )
      .order(created_at: :desc, name: :asc)
      .limit(50)
      .offset(100)

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "raise an exception if parameter data is invalid" do
    params = { "order" => ["name"] }

    expect { klass.new(Ticket.all, params).apply }
      .to raise_error(Parelation::Errors::Parameter, "the order parameter is invalid")
  end
end
