ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "account", :action => 'welcome'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # sorting routes for candidate
  map.connect 'candidates/by/:category', :controller => 'candidates', :action => 'list'
  # sorting routes for all candidate
  map.connect 'candidates/all_by/:category', :controller => 'candidates', :action => 'list_all'
  # filter routes for candidate
  map.connect 'candidates/only/:filter', :controller => 'candidates', :action => 'list'
  # sorted filter routes for candidate
  map.connect 'candidates/only/:filter/by/:category', :controller => 'candidates', :action => 'list'
  # candidates for corridor
  map.connect 'candidates/in/:coridor', :controller => 'candidates', :action => 'list'
  # add path for prijimacky
  map.connect 'prijimacky/:action/:id', :controller => 'form'
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
