class Parelation::Criteria::Offset < Parelation::Criteria

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!(param =~ /^offset$/)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.offset(offset)
  end

  private

  # Alias for {#value}.
  #
  def offset
    value
  end
end
