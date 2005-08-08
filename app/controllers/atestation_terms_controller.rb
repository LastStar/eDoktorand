class AtestationTermsController < ApplicationController
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_person
  # prints actual atestation if any exists
  # dean and faculty secretary should have chance to create new one
  def index
    @title = _("Atestation")
    @atestation_term = AtestationTerm.actual(@person.faculty)
  end
  # creates atestation
  def create
    atestation_term = AtestationTerm.new(params[:atestation_term])
    atestation_term.faculty_id = @person.faculty.id 
    atestation_term.save 
    render(:partial => 'saved', :locals => {:atestation_term => atestation_term})
  end

end
