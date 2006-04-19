class StudentsController < ApplicationController
  include LoginSystem
  layout 'employers', :except => [:time_form, :filter, :list_xls]
  before_filter :prepare_user, :set_title, :login_required
  before_filter :prepare_order, :prepare_filter, :except => [:show,
    :contact]
  before_filter :prepare_conditions

  def index
    do_filter
    render(:action => 'list')
  end
  
  def list_xls
    do_filter
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    headers['Cache-Control'] = ''
  end
  # searches in students lastname
  def search
    conditions = [' AND people.lastname like ?']
    conditions << "#{@params['search_field']}%"
    @indices = Index.find_for(@user, :conditions => conditions, :order => 
      'people.lastname, study_plans.created_on')
    render(:partial => 'list')
  end
  
  # filters students
  def filter
    do_filter
    render(:partial => 'list')
  end
  
  # multiple filtering
  def multiple_filter
    @indices = Index.find_by_criteria(:faculty => @params['filter_by_faculty'],
      :year => @params['filter_by_year'].to_i, :department => 
      @params['filter_by_department'].to_i, :coridor => 
      @params['filter_by_coridor'].to_i, :status => @params['filter_by_status'],
      :study_status => @params['filter_by_study_status'], :form => 
      @params['filter_by_form'].to_i, :user => @user, :order => 'people.lastname')
    render(:partial => 'list')
  end
  
  # renders student details
  def show
    index = Index.find(@params['id'])
    render(:partial => 'show', :locals => {:index => index})
  end
  
  # renders contact for student
  def contact
    render_partial('contact', :student =>
      Student.find(@params['id']))
  end
  
  # finishes study
  def finish
    @index = Index.find(@params['id'])
    date = @params['date']
    @index.finish!(Date.civil(date['year'].to_i, date['month'].to_i))
    render(:inline => "<%= redraw_student(@index) %>")
  end
  
  # unfinishes study
  def unfinish
    @index = Index.find(@params['id'])
    @index.unfinish!
    render(:inline => "<%= redraw_student(@index) %>")
  end
  
  # switches study on index
  def switch_study
    @index = Index.find(@params['id'])
    date = @params['date']
    @index.switch_study!(Date.civil(date['year'].to_i, date['month'].to_i))
    render(:inline => "<%= redraw_student(@index) %>")
  end

  # supervise scholarship by faculty_secretary
  def supervise_scholarship_claim
    @index = Index.find(@params['id'])
    @student = @index.student
    @student.update_attribute('scholarship_supervised_at', Time.now)
    render(:inline => "<%= redraw_student(@index) %>")
  end

  # renders time form for other actions
  def time_form
    @form_url = {:action => @params['form_action'], :id => @params['id']}
    @form_url[:controller] = @params['form_controller'] || 'students'
    @index = Index.find(@params['id'])
  end
  private
  
  # sets title of the controller
  def set_title
    @title = _("Students")
  end
  
  # prepares order variable for listin 
  # TODO create some better mechanism to do ordering
  def prepare_order
    @order = 'people.lastname, study_plans.created_on'
  end
  
  # prepares filter variable
  def prepare_filter 
    @filters = [[_('waiting for my review'), 2], [_("all students"), 0], 
      [_('all studying'), 3]]
    if (@user.has_one_of_roles?(['leader', 'dean', 'vicerector']))
      if !@user.person.indexes.empty?
        @filters.concat([[_("my students"), 1], [_('my studying'), 4]])
      end
    end
    # default filter to waiting for approvement 
    unless @user.has_one_of_roles?(['department_secretary', 'faculty_secretary'])
      @session['filter'] ||= 2 
    else
      @session['filter'] ||= -1
    end
  end

  def do_filter
    @filter = @params['filter_by'] || @session['filter']
    case @filter.to_i
    when 4
      @indices = Index.find_tutored_by(@user, :unfinished => true)
    when 3
      @indices = Index.find_studying_for(@user)
    when 2
      @indices = Index.find_waiting_for_statement(@user)
    when 1
      @indices = Index.find_tutored_by(@user, :order => 'people.lastname')
    when 0
      @indices = Index.find_for(@user, :order => @order)
    end
    @session['filter'] = @filter
  end
end
