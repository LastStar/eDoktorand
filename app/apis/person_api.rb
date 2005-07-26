class PersonAPI < ActionWebService::API::Base
  inflect_names false
  api_method(:getUIC, :expects => [{'rcToLookup' => String}],
  :returns => [[String]])
end
