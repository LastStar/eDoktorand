class SubjectsController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @subject_pages, @subjects = paginate :subject, :per_page => 10
  end

  def show
    @subject = Subject.find(@params[:id])
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(@params[:subject])
    if @subject.save
      flash['notice'] = 'Subject was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @subject = Subject.find(@params[:id])
  end

  def update
    @subject = Subject.find(@params[:id])
    if @subject.update_attributes(@params[:subject])
      flash['notice'] = 'Subject was successfully updated.'
      redirect_to :action => 'show', :id => @subject
    else
      render_action 'edit'
    end
  end

  def destroy
    Subject.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
