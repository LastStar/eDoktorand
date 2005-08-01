class StudentsController < ApplicationController
  include LoginSystem
  model :student
  model :user
  model :leader
  model :dean
  model :faculty_secretary
  layout 'employers'
  before_filter :login_required
  before_filter :set_title
  before_filter :prepare_conditions
  # lists all students
  def index
    list
    render_action 'list'
  end
  # lists all students
  def list
    @indexes = Index.find(:all, :conditions => @conditions, :include =>
    [:study_plan, :student])
  end
  # show student's detail
  def show
    @student = Student.find(@params[:id])
  end
  # searches in students lastname
  def search
    @conditions.first <<  ' AND lastname like ?'
    @conditions << "#{@params['search_field']}%"
    @indexes = Student.find(:all, :conditions => @conditions, :include =>
      :index).map {|s| s.index}
    render_partial "list"
  end
  def new
    @student = Student.new
  end
  def create
    @student = Student.new(@params[:student])
    if @student.save
      flash['notice'] = 'Student was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end
  def edit
    @student = Student.find(@params[:id])
  end
  def update
    @student = Student.find(@params[:id])
    if @student.update_attributes(@params[:student])
      flash['notice'] = 'Student was successfully updated.'
      redirect_to :action => 'show', :id => @student
    else
      render_action 'edit'
    end
  end
  def destroy
    Student.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
  # renders contact for student
  def contact
    render_partial('contact', :student =>
      Student.find(@params['id']))
  end
  private
  # sets title of the controller
  def set_title
    @title = _("Students")
  end
end
