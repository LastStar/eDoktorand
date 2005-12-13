class StudentsController < ApplicationController
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :set_title, :prepare_user
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
    @indices = Index.find_for_user(@user, :include => [:study_plan, :student,
      :disert_theme, :department, :study, :coridor], :order => @order)
  end
  # show student's detail
  def show
    @student = Student.find(@params[:id])
  end
  # searches in students lastname
  def search
    conditions = [' AND people.lastname like ?']
    conditions << "#{@params['search_field']}%"
    @indices = Index.find_for_user(@user, :conditions => conditions, :include =>
      [:study_plan, :student, :disert_theme, :department, :study, :coridor],
      :order => 'people.lastname, study_plans.created_on')
    render(:partial => 'list')
  end
  # filters students
  def filter(options = {})
    @filter = @params['filter_by'] || @session['filter']
    case @filter
    when "2"
      @indices = Index.find_waiting_for_statement(@user)
    when "1"
      @indices = Index.find_all_by_tutor_id(@user.person.id, :include => [:study_plan,
        :student, :disert_theme, :department, :study, :coridor], :order => 'people.lastname')
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
    @indices = Index.find_by_criteria(:faculty => @params['filter_by_faculty'],
      :year => @params['filter_by_year'].to_i, :department => 
      @params['filter_by_department'].to_i, :coridor => 
      @params['filter_by_coridor'].to_i, :status => @params['filter_by_status'],
      :study_status => @params['filter_by_study_status'], :user => @user, 
      :order => 'people.lastname')
    render(:partial => 'list')
  end
  # renders contact for student
  def contact
    render_partial('contact', :student =>
      Student.find(@params['id']))
  end
  # finishes study
  def finish
    @index = Index.find(@params['id'])
    @index.update_attribute('finished_on', Time.now)
    render(:inline => "<%= redraw_student(@index) %>")
  end
  # unfinishes study
  def unfinish
    @index = Index.find(@params['id'])
    @index.update_attribute('finished_on', nil)
    render(:inline => "<%= redraw_student(@index) %>")
  end
  # switches study on index
  def switch_study
    @index = Index.find(@params['id'])
    @index.switch_study
    render(:inline => "<%= redraw_student(@index) %>")
  end

  # supervise scholarship by faculty_secretary
  def supervise_scholarship_claim
    @index = Index.find(@params['id'])
    @student = @index.student
    @student.update_attribute('scholarship_supervised_date', Time.now)
    render(:inline => "<%= redraw_student(@index) %>")
  end

  private
  # sets title of the controller
  def set_title
    @title = _("Students")
  end
  # prepares order variable for listin 
  # TODO create some better mechanism to do ordering
  def prepare_order
# add url driven ordering
    @order = 'people.lastname, study_plans.created_on'
  end
  # prepares filter variable
  def prepare_filter 
    @filters = [[_("all students"), 0]]
    # default filter to waiting for approvement 
    @session['filter'] ||= @user.has_one_of_roles?(['vicerector', 'leader', 'dean', 'tutor']) ? 
    '2' : '0' 
    if (@user.has_one_of_roles?(['leader', 'dean', 'vicerector']))
      if !@user.person.indexes.empty?
        @filters.concat([[_("my students"), 1]])
      end
      @filters.concat([[_('waiting for my review'), 2]])
    end
  end
end
