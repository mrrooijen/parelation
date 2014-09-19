require "spec_helper"

describe Parelation::Helpers do

  class ExampleController
    include Parelation::Helpers

    def params
      { "where" => { "state" => "open" } }
    end

    def index
      parelate(Ticket.all)
    end
  end

  it "should parelate the ticket criteria chain" do
    expect(ExampleController.new.index.to_sql)
      .to eq(Ticket.all.where(state: 'open').to_sql)
  end
end
