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
end
