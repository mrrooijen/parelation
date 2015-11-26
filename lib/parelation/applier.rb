class Parelation::Applier

  # @return [Array] the list of active criteria classes
  #   that are used to narrow down database results.
  #
  CRITERIA = [
    Parelation::Criteria::Select,
    Parelation::Criteria::Limit,
    Parelation::Criteria::Offset,
    Parelation::Criteria::Order,
    Parelation::Criteria::Query,
    Parelation::Criteria::Where,
  ]

  # @return [ActiveRecord::Relation]
  #
  attr_reader :chain

  # @return [ActionController::Parameters, Hash]
  #
  attr_reader :params

  # @param chain [ActionController::Relation] the base chain to build on.
  # @param params [ActionController::Parameters, Hash] user input via params.
  #
  def initialize(chain, params)
    @chain = chain
    @params = params
  end

  # @return [ActiveRecord::Relation] the criteria-applied {#chain}.
  #
  def apply
    @apply ||= apply_to_chain
  end

  private

  # Iterates over each user-provided parameter and incrementally
  # updates the {#chain} to incorporate the user-requested criteria.
  #
  # @return [ActiveRecord::Relation]
  #
  def apply_to_chain
    params.each do |param, value|
      CRITERIA.each do |criteria|
        if criteria.match?(param)
          begin
            @chain = criteria.new(chain, param, value).call
          rescue
            raise Parelation::Errors::Parameter,
              "the #{param} parameter is invalid"
          end
        end
      end
    end

    chain
  end
end
