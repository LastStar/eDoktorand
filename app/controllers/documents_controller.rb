class DocumentsController < ApplicationController

  def index
    list
    render(:action => :list)
  end

  def list
    @documents = Document.find(:all)
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(params[:document])
    if @document.save
      flash['notice'] = 'Document was successfully created.'
      redirect_to :action => 'list'
    else
      render(:action => :new)
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      flash['notice'] = 'Document was successfully updated.'
      redirect_to :action => 'show', :id => @document
    else
      render(:action => :edit)
    end
  end
  
  # prints diploma supplement to pdf
  def diploma_supplement_for_employer
    @employer = true
    @diploma_supplement = DiplomaSupplement.find(params[:id])
    respond_to do |format|
     format.html {render :action => 'diploma_supplement'}
     format.pdf {render :action =>'diploma_supplement', :layout => false}
    end

  end

  # prints diploma supplement to pdf
  def diploma_supplement
    @diploma_supplement = DiplomaSupplement.find(params[:id])
    respond_to do |format|
     format.html
     format.pdf {render :layout => false}
    end

  end

  # prints list of tutors by specializations to pdf
  def tutors_by_specialization
    @faculty = Faculty.find_by_short_name(params[:id])
    @specializations = @faculty.specializations
  end
end
