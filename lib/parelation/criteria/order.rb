class Parelation::Criteria::Order
  include Parelation::Criteria

  require_relative "order/object"

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!(param =~ /^order$/)
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
