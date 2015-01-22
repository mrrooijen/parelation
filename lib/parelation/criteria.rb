class Parelation::Criteria

  # @return [ActiveRecord::Relation] the current criteria chain
  #
  attr_reader :chain

  # @return [String] the param param
  #
  attr_reader :param

  # @return [String] the param value
  #
  attr_reader :value

  # @param chain [ActiveRecord::Relation]
  # @param param [String]
  # @param value [String, Array, Hash]
  #
  def initialize(chain, param, value)
    @chain = chain
    @param = param.clone
    @value = value.clone
  end
end
