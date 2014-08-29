  class Parelation::Criteria::Where::DirectionalQueryApplier

    # @return [Hash] keyword to operator mappings
    #
    OPERATOR_MAPPING = {
      "where_gt" => ">",
      "where_gte" => ">=",
      "where_lt" => "<",
      "where_lte" => "<="
    }

    # @return [String]
    #
    attr_reader :operator

    # @return [Hash]
    #
    attr_reader :criteria

    # @return [ActiveRecord::Relation]
    #
    attr_reader :chain

    # @param operator [String] the named operator from the params
    # @param criteria [Hash] the data to build query operations with
    # @param chain [ActiveRecord::Relation] the chain to apply to
    #
    def initialize(operator, criteria, chain)
      @operator = operator
      @criteria = criteria
      @chain = chain
    end

    # @return [ActiveRecord::Relation] the chain with newly applied operations
    #
    def apply
      criteria.inject(chain) do |chain, (key, value)|
        chain.where(sql, key, value)
      end
    end

    private

    # @return [String] the base SQL template to build queries on-top of
    #
    def sql
      %Q{"#{chain.arel_table.name}".? #{OPERATOR_MAPPING[operator]} ?}
    end
  end
