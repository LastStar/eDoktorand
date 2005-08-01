class AtestationTermsController < ApplicationController
  def index
    list
    render :action => 'list'
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
    @atestation_terms = AtestationTerms.new(params[:atestation_terms])
    if @atestation_terms.save
      flash[:notice] = 'AtestationTerms was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
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
