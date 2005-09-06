class StudentsController < ApplicationController
  include LoginSystem
  model :user
  model :tutor
  model :leader
  model :dean
  model :student
  model :faculty_secretary
  layout 'employers'
  before_filter :login_required, :set_title, 
  :prepare_user
  before_filter :prepare_order, :prepare_conditions, :prepare_filter, :except => [:show,
  :contact]
  
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
    @filter = @params['filter_by'] || @session['filter']
    case @filter
    when "2"
      @conditions.first << ' AND (study_plans.approved_on IS NULL OR
      disert_themes.approved_on IS NULL)'
      list
      @indices = @indices.select {|i| i.statement_for(@user.person)} 
    when "1"
      @indices = @user.person.indexes
    when "0"
      list
    end
    @session['filter'] = @filter
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
    # default filter to waiting for approvement 
    @session['filter'] ||= '2'
    if (@user.person.is_a?(Leader) || @user.person.is_a?(Dean)) && !@user.person.indexes.empty?
     @filters <<  [_("my students"), 1]
    end
  end
end
