Dependencies.mechanism                             = :load
ActionController::Base.consider_all_requests_local = true
ActionController::Base.perform_caching             = false
BREAKPOINT_SERVER_PORT = 42531
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:database_manager => CGI::Session::ActiveRecordStore)
