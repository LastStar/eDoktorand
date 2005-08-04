class StudentsController < ApplicationController
  include LoginSystem
  model :student
  model :user
  model :leader
  model :dean
  model :faculty_secretary
  layout 'employers'
  before_filter :login_required, :set_title, :prepare_conditions,
  :prepare_person, :prepare_order 
  
  # lists all students
  def index
    list
    render_action 'list'
  end
  # lists all students
  def list
    @indices = Index.find(:all, :conditions => @conditions, :include =>
    [:study_plan, :student], :order => @order)
  end
  # show student's detail
  def show
    @student = Student.find(@params[:id])
  end
  # searches in students lastname
  def search
    @conditions.first <<  ' AND lastname like ?'
    @conditions << "#{@params['search_field']}%"
    @indices = Student.find(:all, :conditions => @conditions, :include =>
      :index).map {|s| s.index}
    if @indices.empty?
      render(:partial => 'search_unsuccesfull')
    else
      render(:partial => 'search_succesfull')
    end
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
  # prepares order variable for listin 
  def prepare_order
    @order = 'study_plans.created_on, study_plans.updated_on desc'
    if @session['user'].person.is_a? Dean || @session['user'].person.is_a?
        FacultySecretary
      @order.concat(', department_id') 
    elsif @session['user'].person.is_a? Leader || @session['user'].person.is_a?
        DepartmentSecretary
      @order.concat(', tutor_id') 
    end
  end
end
