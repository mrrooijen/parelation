module Parelation
  module Errors
    require "parelation/errors/parameter"
  end

  module Criteria
    require "parelation/criteria/select"
    require "parelation/criteria/limit"
    require "parelation/criteria/offset"
    require "parelation/criteria/order"
    require "parelation/criteria/query"
    require "parelation/criteria/where"
  end

  require "parelation/applier"
  require "parelation/criteria"
  require "parelation/helpers"
  require "parelation/version"
end
