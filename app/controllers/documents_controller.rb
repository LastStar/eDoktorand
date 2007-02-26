class DocumentsController < ApplicationController

  def index
    list
    render_action 'list'
  end

  def list
    @documents = Document.find_all
  end

  def show
    @document = Document.find(@params[:id])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(@params[:document])
    if @document.save
      flash['notice'] = 'Document was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @document = Document.find(@params[:id])
  end

  def update
    @document = Document.find(@params[:id])
    if @document.update_attributes(@params[:document])
      flash['notice'] = 'Document was successfully updated.'
      redirect_to :action => 'show', :id => @document
    else
      render_action 'edit'
    end
  end

  def destroy
    Document.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end

  def diploma_supplement
    @index = Index.find params[:id]
    @student = @index.student
  end
end
