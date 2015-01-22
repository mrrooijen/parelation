class Parelation::Criteria::Limit < Parelation::Criteria

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!(param =~ /^limit$/)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.limit(limit)
  end

  private

  # Alias for {#value}.
  #
  def limit
    value
  end
end
