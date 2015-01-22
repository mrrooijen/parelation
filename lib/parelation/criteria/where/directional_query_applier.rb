class Parelation::Criteria::Where::DirectionalQueryApplier

  # @return [Hash] keyword to operator mappings
  #
  OPERATOR_MAPPING = {
    "where_gt" => ">",
    "where_gte" => ">=",
    "where_lt" => "<",
    "where_lte" => "<="
  }

  # @return [ActiveRecord::Relation]
  #
  attr_reader :chain

  # @return [String]
  #
  attr_reader :operator

  # @return [String]
  #
  attr_reader :field

  # @return [String]
  #
  attr_reader :value

  # @param chain [ActiveRecord::Relation] the chain to apply to
  # @param operator [String] the named operator from the params
  # @param field [String] the field to query on
  # @param value [String] the value of the query
  #
  def initialize(chain, operator, field, value)
    @chain = chain
    @operator = operator
    @field = field
    @value = value
  end

  # @return [ActiveRecord::Relation] the chain with newly applied operations
  #
  def apply
    chain.where(sql, field, value)
  end

  private

  # @return [String] the base SQL template to build queries on-top of
  #
  def sql
    %Q{"#{chain.arel_table.name}".? #{OPERATOR_MAPPING[operator]} ?}
  end
end
