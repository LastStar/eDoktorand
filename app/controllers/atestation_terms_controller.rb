class AtestationTermsController < ApplicationController
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_user
  # prints actual atestation if any exists
  # dean and faculty secretary should have chance to create new one
  def index
    @title = _("Atestation")
    @atestation_terms = {}
    @atestation_terms['actual'] = AtestationTerm.actual(@user.person.faculty)
    if AtestationTerm.next?(@user.person.faculty)
      @atestation_terms['next'] = AtestationTerm.next(@user.person.faculty)
    else
      @atestation_term = AtestationTerm.new
    end
  end
  # creates atestation
  def create
    atestation_term = AtestationTerm.new(params[:atestation_term])
    atestation_term.faculty_id = @user.person.faculty.id 
    atestation_term.save 
    render(:partial => 'saved', :locals => {:atestation_term => atestation_term})
  end

end
