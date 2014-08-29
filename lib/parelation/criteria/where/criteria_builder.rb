class Parelation::Criteria::Where::CriteriaBuilder

  # @return [Hash]
  #
  attr_reader :value

  # @return [ActiveRecord::Relation]
  #
  attr_reader :chain

  # @param value [Hash] the user-provided criteria
  # @param chain [ActiveRecord::Relation]
  #
  def initialize(value, chain)
    @value = value
    @chain = chain
  end

  # @return [Hash] criteria that can be passed into
  #   the +where+ method of an ActiveRecord::Relation chain.
  #
  def build
    value.inject(Hash.new) do |hash, (field, value)|
      values = [value].flatten

      if values.count > 1
        assign_array(hash, field, values)
      else
        assign_value(hash, field, values)
      end

      hash
    end
  end

  private

  # Assigns each of the provided values to the +hash+ and casts
  # the value to a database-readable value.
  #
  # @param hash [Hash]
  # @param field [Symbol]
  # @param values [Array]
  #
  def assign_array(hash, field, values)
    values.each { |val| (hash[field] ||= []) << cast(field, val) }
  end

  # Assigns the first value of the provided values array
  # to the +hash+ and casts it to a database-readable value.
  #
  # @param hash [Hash]
  # @param field [Symbol]
  # @param values [Array]
  #
  def assign_value(hash, field, values)
    hash[field] = cast(field, values[0])
  end

  # @param field [Symbol]
  # @param value [String]
  #
  def cast(field, value)
    Parelation::Criteria::Where::Caster
      .new(field, value, chain.arel_table.engine).cast
  end
end
