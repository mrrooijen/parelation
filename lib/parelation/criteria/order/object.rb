class Parelation::Criteria::Order::Object

  # @return [Hash] the possible directions (asc, desc)
  #   for database queries.
  #
  DIRECTIONS = {
    "asc" => :asc,
    "desc" => :desc,
  }

  # @return [String]
  #
  attr_reader :order

  # @param order [String]
  #
  def initialize(order)
    @order = order
  end

  # @return [Hash] returns criteria for {ActiveRecord::Relation}.
  #
  # @example
  #   { created_at: :asc }
  #
  def criteria
    { field => direction }
  end

  private

  # @return [String] the name of the field to perform the ordering on.
  #
  def field
    parts.first || ""
  end

  # @return [Symbol, nil] the direction to order {#field},
  #   either :asc or :desc.
  #
  def direction
    DIRECTIONS[parts.last]
  end

  # @return [Array<String, nil>] the criteria chunks (separated by +:+).
  #
  def parts
    @parts ||= order.split(":")
  end
end
