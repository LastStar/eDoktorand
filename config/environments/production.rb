Dependencies.mechanism                             = :require
ActionController::Base.consider_all_requests_local = false
ActionController::Base.perform_caching             = true
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:database_manager => CGI::Session::ActiveRecordStore)
