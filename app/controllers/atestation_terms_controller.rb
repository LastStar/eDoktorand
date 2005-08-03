class AtestationTermsController < ApplicationController
  model :user
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_person
  # prints actual atestation if any exists
  # dean and faculty secretary should have chance to create new one
  def index
    @title = _("Atestation")
    @atestation_term = AtestationTerm.actual
  end

  def list
    @atestation_terms_pages, @atestation_terms = paginate :atestation_terms, :per_page => 10
  end

  def show
    @atestation_terms = AtestationTerms.find(params[:id])
  end

  def new
    @atestation_terms = AtestationTerms.new
  end

  def create
    atestation_term = AtestationTerm.new(params[:atestation_term])
    atestation_term.faculty_id = @person.faculty.id 
    atestation_term.save 
    render(:partial => 'saved', :locals => {:atestation_term => atestation_term})
  end

  def edit
    @atestation_terms = AtestationTerms.find(params[:id])
  end

  def update
    @atestation_terms = AtestationTerms.find(params[:id])
    if @atestation_terms.update_attributes(params[:atestation_terms])
      flash[:notice] = 'AtestationTerms was successfully updated.'
      redirect_to :action => 'show', :id => @atestation_terms
    else
      render :action => 'edit'
    end
  end

  def destroy
    AtestationTerms.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
