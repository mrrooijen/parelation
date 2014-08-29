module Parelation::Helpers

  # Shorthand method used in ActionController controllers for converting
  # and applying parameters to ActionController::Relation criteria chains.
  #
  # @param object [ActiveRecord::Relation]
  # @return [ActiveRecord::Relation]
  #
  def parelate(object)
    Parelation::Applier.new(object, params).apply
  end
end
