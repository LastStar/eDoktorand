ActionController::Routing::Routes.draw do |map|
  Translate::Routes.translation_ui(map) if RAILS_ENV != "production"

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "account", :action => 'welcome'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # add path for table changer
  map.connect 'table/:controller/:action', :prefix => 'table_'

  ### table versions 
  # sorting routes for candidate
  map.connect 'table/:controller/by/:category', :action => 'list', :prefix => 'table_'

  # sorting routes for all candidate
  map.connect 'table/:controller/all_by/:category', :action => 'list_all', 
    :prefix => 'table_'

  # filter routes for candidate
  map.connect 'table/:controller/only/:filter', :action => 'list', :prefix => 'table_'

  # sorted filter routes for candidate
  map.connect 'table/:controller/only/:filter/by/:category', :action => 'list', 
    :prefix => 'table_'
  
  # candidates for corridor
  map.connect 'table/candidates/in/:specialization', :controller => 'candidates', 
    :action => 'list_all', :prefix => 'table_'

  # sorting routes for candidate
  map.connect ':controller/by/:category', :action => 'list'

  # sorting routes for all candidate
  map.connect ':controller/all_by/:category', :action => 'list_all'

  # filter routes for candidate
  map.connect ':controller/only/:filter', :action => 'list'

  # sorted filter routes for candidate
  map.connect ':controller/only/:filter/by/:category', :action => 'list'

  # candidates for corridor
  map.connect 'candidates/in/:specialization', :controller => 'candidates', 
    :action => 'list_all'

  # add path for prijimacky
  map.connect 'prijimacky/:action/:id', :controller => 'form', :lang => 'cs'

  # add path for admittance
  map.connect 'application_form/:action/:id', :controller => 'form', :lang => 'en'

  # login url
  map.login 'login', :controller => 'account', :action => 'login'

  # error url
  map.error 'error', :controller => 'account', :action => 'error'

  # locale url
  map.locale 'locale/:lang', :controller => 'account', :action =>
    'login'

  # students url
  map.students 'students', :controller => 'students', :action => 'index'

  # welcome url
  map.welcome 'welcome', :controller => 'account', :action => 'welcome'

  # for approvement purposes
  map.connect 'students/:action/:id', :controller => 'students'
  map.connect 'indices/:action/:id', :controller => 'students'

  # time filtering for probation terms
  map.connect 'probation_terms/in/:period', :controller => 'probation_terms'

  # year filtering for exams
  map.connect 'exams/year/:this_year', :controller => 'exams', :action => 'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
