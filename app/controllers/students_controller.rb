class StudentsController < ApplicationController
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :set_title, 
  :prepare_user
  before_filter :prepare_order, :prepare_filter, :except => [:show,
  :contact]
  before_filter :prepare_conditions
  # lists all students
  def index
    filter(:dont_render => true)
    render(:action => 'list')
  end
  # lists all students
  def list
    @indices = Index.find_for_user(@user, :include =>
    [:study_plan, :student, :disert_theme], :order => @order)
  end
  # show student's detail
  def show
    @student = Student.find(@params[:id])
  end
  # searches in students lastname
  def search
    prepare_conditions
    @conditions.first <<  ' AND lastname like ?'
    @conditions << "#{@params['search_field']}%"
    @indices = Student.find(:all, :conditions => @conditions, :include =>
    :index).map {|s| s.index}.compact
    render(:partial => 'list')
  end
  # filters students
  def filter(options = {})
    @filter = @params['filter_by'] || @session['filter']
    case @filter
    when "2"
      @indices = Index.find_waiting_for_statement(@user)
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
  # multiple filtering
  def multiple_filter
    year = @params['filter_by_year'].to_i
    department = @params['filter_by_department'].to_i
    coridor = @params['filter_by_coridor'].to_i
    @indices = Index.find_by_criteria(:year => year, :department => department,
    :coridor => coridor)
    render(:partial => 'list')
  end
  # renders contact for student
  def contact
    render_partial('contact', :student =>
      Student.find(@params['id']))
  end
  # scholarship list preparation
  def scholarship
    conditions = [' AND indices.study_id = 1']
    @indices = Index.find_for_user(@user, :conditions => conditions)
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
    if @session['user'].has_one_of_roles?(['dean', 'faculty_secretary'])
      @order.concat(', department_id') 
    elsif @session['user'].has_one_of_roles?(['leader',
      'department_secretary'])
      @order.concat(', tutor_id') 
    end
  end
  # prepares filter variable
  def prepare_filter 
    @filters = [[_("all students"), 0], [_("waiting for my review"), 2]]
    # default filter to waiting for approvement 
    @session['filter'] ||= @user.has_one_of_roles?(['leader', 'dean', 'tutor']) ? 
    '2' : '0' 
    if (@user.has_one_of_roles?(['leader', 'dean'])) && !@user.person.indexes.empty?
      @filters <<  [_("my students"), 1]
    end
  end

end
