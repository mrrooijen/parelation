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

  it "should add = criteria to the chain when argument is a value" do
    criteria = klass.new(Ticket.all, "where", state: "open").call
    ar_query = Ticket.where(state: "open")

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add = criteria to the chain when argument is an array" do
    criteria = klass.new(Ticket.all, "where", state: ["open"]).call
    ar_query = Ticket.where(state: "open")

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add IN criteria to the chain when values are many" do
    criteria = klass.new(Ticket.all, "where", state: ["open", "pending"]).call
    ar_query = Ticket.where(state: ["open", "pending"])

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add != criteria to the chain when argument is a value" do
    criteria = klass.new(Ticket.all, "where_not", state: "open").call
    ar_query = Ticket.where.not(state: "open")

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add != criteria to the chain when argument is an array" do
    criteria = klass.new(Ticket.all, "where_not", state: "open").call
    ar_query = Ticket.where.not(state: "open")

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  it "should add NOT IN criteria to the chain when values are many" do
    criteria = klass.new(Ticket.all, "where_not", state: ["open", "pending"]).call
    ar_query = Ticket.where.not(state: ["open", "pending"])

    expect(criteria.to_sql).to eq(ar_query.to_sql)
  end

  [%w[where_gt >], %w[where_gte >=], %w[where_lt <], %w[where_lte <=]]
    .each do |(operator, symbol)|

    it "should add #{symbol} criteria to the chain" do
      criteria = klass.new(Ticket.all, operator, created_at: "2014-08-26T19:20:44Z").call
      ar_query = Ticket.where(
        %Q{"tickets".'created_at' #{symbol} ?}, "2014-08-26 19:20:44.000000"
      )

      expect(criteria.to_sql).to eq(ar_query.to_sql)
    end

    it "should add multiple #{symbol} criteria to the chain" do
      criteria = klass.new(Ticket.all, operator, created_at: "2014-08-26T19:20:44Z", position: "5").call
      ar_query = Ticket.where(%Q{"tickets".'created_at' #{symbol} ?}, "2014-08-26 19:20:44.000000")
                       .where(%Q{"tickets".'position' #{symbol} ?}, 5)

      expect(criteria.to_sql).to eq(ar_query.to_sql)
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
      expect(chain.to_sql).to eq(@project1.tickets.where(project_id: @project2.id).to_sql)
    end
  end

  describe "casting:boolean" do

    ["1", "t", "true"].each do |string_bool|
      it "should cast #{string_bool} to true" do
        criteria = klass.new(Ticket.all, "where", resolved: string_bool).call
        ar_query = Ticket.where(resolved: true)

        expect(criteria.to_sql).to eq(ar_query.to_sql)
      end
    end

    ["0", "f", "false"].each do |string_bool|
      it "should cast #{string_bool} to false" do
        criteria = klass.new(Ticket.all, "where", resolved: string_bool).call
          ar_query = Ticket.where(resolved: false)

          expect(criteria.to_sql).to eq(ar_query.to_sql)
      end
    end
  end

  describe "casting:integer" do

    it "should cast a string to integer" do
      criteria = klass.new(Ticket.all, "where", position: "5").call
      ar_query = Ticket.where(position: 5)

      expect(criteria.to_sql).to eq(ar_query.to_sql)
    end
  end

  describe "casting:float" do

    it "should cast a string to float" do
      criteria = klass.new(Ticket.all, "where", rating: "2.14").call
      ar_query = Ticket.where(rating: 2.14)

      expect(criteria.to_sql).to eq(ar_query.to_sql)
    end
  end

  describe "casting:datetime" do

    it "should cast a string to time" do
      criteria = klass.new(Ticket.all, "where", created_at: "2014-01-01T00:00:00Z").call
      ar_query = Ticket.where(created_at: '2014-01-01 00:00:00.000000')

      expect(criteria.to_sql).to eq(ar_query.to_sql)
    end
  end
end
