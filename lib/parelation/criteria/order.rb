class Parelation::Criteria::Order < Parelation::Criteria

  require_relative "order/object"

  # @return [Regexp] The order format.
  #
  ORDER_FORMAT = /^order$/

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!param.match(ORDER_FORMAT)
  end

  # Applies the specified orderings to {#chain}.
  #
  # @return [ActiveRecord::Relation] the modified chain.
  #
  def call
    orders.inject(chain) do |chain, order|
      chain.order(order.criteria)
    end
  end

  private

  # @return [Array<Parelation::Criteria::Order::Object>] an
  #   array of attributes to order.
  #
  def orders
    @orders ||= [value].flatten.map { |order| Object.new(order) }
  end
end
