class Parelation::Criteria::Select
  include Parelation::Criteria

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!(param =~ /^select$/)
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
