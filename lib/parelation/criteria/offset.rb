class Parelation::Criteria::Offset < Parelation::Criteria

  # @return [Regexp] the offset format.
  #
  OFFSET_FORMAT = /^offset$/

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!param.match(OFFSET_FORMAT)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.offset(value)
  end
end
