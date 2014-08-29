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

    expect(klass.new(Project.create.tickets, params).apply.to_sql)
      .to eq(%Q{SELECT  "tickets"."id", "tickets"."name", } +
             %Q{"tickets"."state", "tickets"."message" FROM "tickets"  } +
             %Q{WHERE "tickets"."project_id" = ? AND "tickets"."state" } +
             %Q{IN ('open', 'pending') AND ("tickets"."state" != 'closed') } +
             %Q{AND ("tickets".'created_at' > '2014-01-01 00:00:00.000000') } +
             %Q{AND ("tickets".'updated_at' >= '2014-01-01 00:00:00.000000') } +
             %Q{AND ("tickets".'created_at' < '2014-01-01 01:00:00.000000') } +
             %Q{AND ("tickets".'updated_at' <= '2014-01-01 01:00:00.000000') } +
             %Q{AND ("tickets"."name" LIKE '%ruby on rails%' } +
             %Q{OR "tickets"."message" LIKE '%ruby on rails%')  } +
             %Q{ORDER BY "tickets"."created_at" DESC, } +
             %Q{"tickets"."name" ASC LIMIT 50 OFFSET 100})
  end

  it "raise an exception if parameter data is invalid" do
    params = { "order" => ["name"] }

    expect { klass.new(Ticket.all, params).apply }
      .to raise_error(Parelation::Errors::Parameter, "the order parameter is invalid")
  end
end
