class Parelation::Criteria::Query
  include Parelation::Criteria

  # @param param [String]
  # @return [TrueClass, FalseClass]
  #
  def self.match?(param)
    !!(param =~ /^query$/)
  end

  # @return [ActiveRecord::Relation]
  #
  def call
    chain.where(*criteria)
  end

  private

  # @return [Array] containing {#chain} criteria.
  #
  def criteria
    [sql] + args
  end

  # @return [String] an SQL statement based on the selected {#attributes}.
  #
  def sql
    template = ->(field) { %Q{"#{chain.arel_table.name}"."#{field}" LIKE ?} }
    attributes.map(&template).join(" OR ")
  end

  # @return [Array] containing the query, one for each field in {#attributes}.
  #
  def args
    attributes.count.times.map { "%#{query}%" }
  end

  # @return [String] the "search" query to perform.
  #
  def query
    @query ||= parts.first
  end

  # @return [Array<String>] an array of attributes to search in.
  #
  def attributes
    @attributes ||= parts.last
  end

  # @return [Array] containing the query and attributes.
  #
  def parts
    @parts ||= [value.keys.first, [value.values.first].flatten]
  end
end
