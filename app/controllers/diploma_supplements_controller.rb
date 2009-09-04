class DiplomaSupplementsController < ApplicationController
  layout 'employers'
  include LoginSystem
  before_filter :prepare_user

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @diploma_supplements = DiplomaSupplement.find_for(@user)
  end

  def new
    if params[:id]
      @diploma_supplement = DiplomaSupplement.new_from_index(params[:id])
    else
      @diploma_supplement = DiplomaSupplement.new_for(@user.person.faculty)
    end
  end

  def create
    @diploma_supplement = DiplomaSupplement.new(params[:diploma_supplement])
    if @diploma_supplement.save
      flash[:notice] = 'DiplomaSupplement was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @diploma_supplement = DiplomaSupplement.find(params[:id])
  end

  def update
    @diploma_supplement = DiplomaSupplement.find(params[:id])
    if @diploma_supplement.update_attributes(params[:diploma_supplement])
      flash[:notice] = 'DiplomaSupplement was successfully updated.'
      redirect_to :controller => :documents, :action => :diploma_supplement,
                  :id => @diploma_supplement
    else
      render :action => 'edit'
    end
  end

  # 
  def destroy
    DiplomaSupplement.find(params[:id]).destroy
    redirect_to :action => :list
  end  
end
