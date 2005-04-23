class ACLControllerController < ApplicationController
  model :user
  before_filter :authorize
  protected
  # provides authorization
  def authorize
    required_perm = "%s/%s" % [@params["controller"], @params["action"]]
    
    

  end
end
