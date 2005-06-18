class StudentsController < ApplicationController
  model :student
  model :user
  model :leader
  model :dean
  model :faculty_secretary
  include LoginSystem
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
    render_partial('student_contact', :student =>
      Student.find(@params['id']))
  end
  private
  # sets title of the controller
  def set_title
    @title = 'Studenti'
  end
  # prepares conditions for various queries
  def prepare_conditions
    @conditions = "null is not null"
    if @session['user'].person.is_a? Dean || @session['user'].person.is_a?
        FacultySecretary
      @conditions = ["department_id IN (" +  @session['user'].person.deanship.faculty.departments.map {|dep|
        dep.id}.join(', ') + ")"]
    elsif @session['user'].person.is_a? Leader || @session['user'].person.is_a?
        DepartmentSecretary
      @conditions = ['department_id = ?', @session['user'].person.leadership.department_id]
    elsif @session['user'].person.is_a? Tutor
      @conditions = ['tutor_id = ?', @session['user'].person.id]
    end
  end
end
