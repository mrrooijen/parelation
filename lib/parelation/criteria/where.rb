class Parelation::Criteria::Where < Parelation::Criteria

  require_relative "where/caster"
  require_relative "where/directional_query_applier"
  require_relative "where/criteria_builder"

  # @return [Regexp] the "where" format.
  #
  WHERE_FORMAT = /^(where|where_(not|gt|gte|lt|lte))$/

  # @param param [String]
  # @return [true, false]
  #
  def self.match?(param)
    !!param.match(WHERE_FORMAT)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    criteria.inject(chain) do |chain, (field, value)|
      case param
      when "where"
        chain.where(field => value)
      when "where_not"
        chain.where.not(field => value)
      when "where_gt", "where_gte", "where_lt", "where_lte"
        DirectionalQueryApplier.new(chain, param, field, value).apply
      end
    end
  end

  private

  # @return [Hash] containing data used to pass to {#chain}'s +where+ method.
  #
  def criteria
    @criteria ||= CriteriaBuilder.new(value, chain).build
  end
end
