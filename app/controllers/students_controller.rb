class StudentsController < ApplicationController
  include LoginSystem
  model :student
  model :user
  model :leader
  model :dean
  model :faculty_secretary
  layout 'employers'
  before_filter :login_required, :set_title, :prepare_conditions,
  :prepare_person, :prepare_order, :prepare_filter 
  
  # lists all students
  def index
    filter(:dont_render => true)
    render(:action => 'list')
  end
  # lists all students
  def list
    @indices = Index.find(:all, :conditions => @conditions, :include =>
    [:study_plan, :student, :disert_theme], :order => @order)
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
    render(:partial => 'list')
  end
  # filters students
  def filter(options = {})
    filter = @params['filter_by'] || @session['filter']
    case filter
    when "2"
      @conditions.first << ' AND study_plans.approved_on IS NULL'
      list
      @indices = @indices.select {|i| i.statement_for(@person)} 
    when "1"
      @indices = @person.indexes
    when "0"
      list
    end
    @session['filter'] = @params['filter_by']
    unless options[:dont_render]
      render(:partial => 'list')
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
  # TODO create some better mechanism to do ordering
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
  # prepares filter variable
  def prepare_filter 
    @filters = [[_("all students"), 0], [_("waitining for my approvement"), 2]]
    @session['filter'] ||= '0' 
    if (@person.is_a?(Leader) || @person.is_a?(Dean)) && !@person.indexes.empty?
     @filters <<  [_("my students"), 1]
    end
  end
end
