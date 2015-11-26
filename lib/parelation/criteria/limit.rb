class Parelation::Criteria::Limit < Parelation::Criteria

  # @return [Regexp] the limit format.
  #
  LIMIT_FORMAT = /^limit$/

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!param.match(LIMIT_FORMAT)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.limit(value)
  end
end
