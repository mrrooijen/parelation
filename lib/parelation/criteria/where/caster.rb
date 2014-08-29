class Parelation::Criteria::Where::Caster

  # @return [String] an array of values that are considered true
  #
  TRUTHY_VALUES = ["1", "t", "true"]

  # @return [String] an array of values that are considered false
  #
  FALSY_VALUES = ["0", "f", "false"]

  # @return [String]
  #
  attr_reader :field

  # @return [String]
  #
  attr_reader :value

  # @return [Class]
  #
  attr_reader :klass

  # @param field [Symbol] the name of the attribute that needs to be casted
  # @param value [String] the value of the attribute that needs to be casted
  # @param klass [Class] the corresponding field's class
  #
  def initialize(field, value, klass)
    @field = field.to_s
    @value = value
    @klass = klass
  end

  # @return [String, Boolean, Time, nil]
  #
  def cast
    case type
    when :boolean
      to_boolean
    when :integer
      to_integer
    when :float
      to_float
    when :datetime
      to_time
    else
      value
    end
  end

  private

  # @return [Symbol]
  #
  def type
    klass.columns_hash[field].type
  end

  # @return [true, false, nil]
  #
  def to_boolean
    TRUTHY_VALUES.include?(value) && (return true)
    FALSY_VALUES.include?(value) && (return false)
  end

  # @return [Integer]
  #
  def to_integer
    value.to_i
  end

  # @return [Float]
  #
  def to_float
    value.to_f
  end

  # @return [Time] the parsed time string
  #
  def to_time
    Time.parse(value)
  end
end
