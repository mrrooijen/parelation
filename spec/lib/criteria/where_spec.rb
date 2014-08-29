require "spec_helper"

describe Parelation::Criteria::Where do

  let(:klass) { Parelation::Criteria::Where }

  it "should match" do
    operators = %w[where where_not where_gt where_gte where_lt where_lte]
    operators.each { |operator| expect(klass.match?(operator)).to eq(true) }
  end

  it "should not match" do
    expect(klass.match?("query")).to eq(false)
  end

  it "should add = criteria to the chain" do
    sql = %Q{SELECT "tickets".* FROM "tickets"  } +
          %Q{WHERE "tickets"."state" = 'open'}

    instance = klass.new(Ticket.all, "where", state: "open")
    expect(instance.call.to_sql).to eq(sql)

    instance = klass.new(Ticket.all, "where", state: ["open"])
    expect(instance.call.to_sql).to eq(sql)
  end

  it "should add IN criteria to the chain" do
    value = { state: ["open", "pending"] }
    expect(klass.new(Ticket.all, "where", value).call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
             %Q{WHERE "tickets"."state" IN ('open', 'pending')})
  end

  it "should add != criteria to the chain" do
    sql = %Q{SELECT "tickets".* FROM "tickets"  } +
          %Q{WHERE ("tickets"."state" != 'open')}

    instance = klass.new(Ticket.all, "where_not", state: "open")
    expect(instance.call.to_sql).to eq(sql)

    instance = klass.new(Ticket.all, "where_not", state: ["open"])
    expect(instance.call.to_sql).to eq(sql)
  end

  it "should add NOT IN criteria to the chain" do
    value = { state: ["open", "pending"] }
    expect(klass.new(Ticket.all, "where_not", value).call.to_sql)
      .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
             %Q{WHERE ("tickets"."state" NOT IN ('open', 'pending'))})
  end

  [%w[where_gt >], %w[where_gte >=], %w[where_lt <], %w[where_lte <=]]
    .each do |(operator, symbol)|

    it "should add #{symbol} criteria to the chain" do
      value = { created_at: "2014-08-26T19:20:44Z" }
      instance = klass.new(Ticket.all, operator, value)

      expect(instance.call.to_sql)
        .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
               %Q{WHERE ("tickets".'created_at' #{symbol} } +
               %Q{'2014-08-26 19:20:44.000000')})
    end

    it "should add multiple #{symbol} criteria to the chain" do
      value = { created_at: "2014-08-26T19:20:44Z", position: "5" }
      instance = klass.new(Ticket.all, operator, value)

      expect(instance.call.to_sql).to eq(
        %Q{SELECT "tickets".* FROM "tickets"  } +
        %Q{WHERE ("tickets".'created_at' #{symbol} '2014-08-26 19:20:44.000000') } +
        %Q{AND ("tickets".'position' #{symbol} 5)}
      )
    end
  end

  describe "relations" do

    before do
      @project1 = Project.create
      @project2 = Project.create
      @ticket1 = @project1.tickets.create
      @ticket2 = @project2.tickets.create
    end

    it "should yield related resources" do
      tickets = @project1.tickets
      expect(tickets.count).to eq(1)
      expect(tickets.first).to eq(@ticket1)
    end

    it "should yield results when using the same foreign key" do
      chain = klass.new(@project1.tickets, "where", project_id: @project1.id).call
      expect(chain.count).to eq(1)
      expect(chain.first).to eq(@ticket1)
    end

    it "should not override foreign key, nor yield results" do
      chain = klass.new(@project1.tickets, "where", project_id: @project2.id).call
      expect(chain.count).to eq(0)
      expect(chain.to_sql)
        .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
               %Q{WHERE "tickets"."project_id" = ? } +
               %Q{AND "tickets"."project_id" = #{@project2.id}})
    end
  end

  describe "casting:boolean" do

    ["1", "t", "true"].each do |string_bool|
      it "should cast #{string_bool} to true" do
        expect(klass.new(Ticket.all, "where", resolved: string_bool).call.to_sql)
          .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
                 %Q{WHERE "tickets"."resolved" = 't'})
      end
    end

    ["0", "f", "false"].each do |string_bool|
      it "should cast #{string_bool} to false" do
        expect(klass.new(Ticket.all, "where", resolved: string_bool).call.to_sql)
          .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
                 %Q{WHERE "tickets"."resolved" = 'f'})
      end
    end
  end

  describe "casting:integer" do

    it "should cast a string to integer" do
      expect(klass.new(Ticket.all, "where", position: "5").call.to_sql)
        .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
               %Q{WHERE "tickets"."position" = 5})
    end
  end

  describe "casting:float" do

    it "should cast a string to float" do
      expect(klass.new(Ticket.all, "where", rating: "2.14").call.to_sql)
        .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
               %Q{WHERE "tickets"."rating" = 2.14})
    end
  end

  describe "casting:datetime" do

    it "should cast a string to time" do
      expect(klass.new(Ticket.all, "where", created_at: "2014-01-01T00:00:00Z").call.to_sql)
        .to eq(%Q{SELECT "tickets".* FROM "tickets"  } +
               %Q{WHERE "tickets"."created_at" = '2014-01-01 00:00:00.000000'})
    end
  end
end
