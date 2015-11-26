class Parelation::Criteria::Select < Parelation::Criteria

  # @return [Regexp] the select format.
  #
  SELECT_FORMAT = /^select$/

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!param.match(SELECT_FORMAT)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.select(*attributes)
  end

  private

  # Alias for {#value}.
  #
  def attributes
    value
  end
end
