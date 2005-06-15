class StudentsController < ApplicationController
  model :student
  model :user
  model :leader
  model :dean
  include LoginSystem
  layout 'employers'
  before_filter :login_required
  before_filter :set_title
  # lists all students
  def index
    list
    render_action 'list'
  end
  # lists all students
  def list
    @pages, @students = paginate(:students, :per_page => 5, :order_by =>
    'lastname')
  end
  # show student's detail
  def show
    @student = Student.find(@params[:id])
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
  private
  # sets title of the controller
  def set_title
    @title = 'Studenti'
  end
end
