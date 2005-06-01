class ExamsController < ApplicationController
  model :user
  include LoginSystem
  layout "employers"
  before_filter :set_title

  def index
    list
    render_action 'list'
  end

  def list
    @exam_pages, @exams = paginate :exam, :per_page => 10
  end

  def show
    @exam = Exam.find(@params[:id])
  end

  def new
    @exam = Exam.new
    @exam.creator = @session['user'].person
  end

  def create
    @exam = Exam.new(@params[:exam])
    if @exam.save
      flash['notice'] = _("Exam was successfully created.")
      redirect_to :action => 'show', :id => @exam
    else
      render_action 'new'
    end
  end

  def edit
    @exam = Exam.find(@params[:id])
  end

  def update
    @exam = Exam.find(@params[:id])
    if @exam.update_attributes(@params[:exam])
      flash['notice'] = _("Exam was successfully updated.")
      redirect_to :action => 'show', :id => @exam
    else
      render_action 'edit'
    end
  end

  def destroy
    Exam.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end

# sets title of the controller
def set_title
  @title = _('Exams')
end
