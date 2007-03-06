class StudentsController < ApplicationController
  include LoginSystem
  helper :study_plans
  layout 'employers', :except => [:edit_citizenship, :edit_display_name, :edit_phone, :edit_email, 
                                  :edit_birthname, :edit_consultant, :edit_tutor,
                                  :time_form, :filter, :list_xls, :edit_account]

  before_filter :prepare_user, :set_title, :login_required
  before_filter :prepare_order, :prepare_filter, :except => [:show,
    :contact]
  before_filter :prepare_conditions, :prepare_student


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
    # TODO redone with class method
    conditions = [' AND people.lastname like ?']
    conditions << "#{params[:search_field]}%"
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
    @indices = Index.find_by_criteria(:faculty => params[:filter_by_faculty],
      :year => params[:filter_by_year].to_i, :department => 
      params[:filter_by_department].to_i, :coridor => 
      params[:filter_by_coridor].to_i, :status => params[:filter_by_status],
      :study_status => params[:filter_by_study_status], :form => 
      params[:filter_by_form].to_i, :user => @user, :order => 'people.lastname')
    render(:partial => 'list')
  end
  
  # renders student details
  def show
    index = Index.find(params[:id])
    render(:partial => 'show', :locals => {:index => index})
  end
  
  # renders contact for student
  def contact
    render_partial('contact', :student =>
      Student.find(params[:id]))
  end
  
  # finishes study
  def finish
    @index = Index.find(params[:id])
    date = params[:date]
    @index.finish!(Date.civil(date['year'].to_i, date['month'].to_i))
    render(:inline => "<%= redraw_student(@index) %>")
  end
  
  # unfinishes study
  def unfinish
    @index = Index.find(params[:id])
    @index.unfinish!
    render(:inline => "<%= redraw_student(@index) %>")
  end
  
  # switches study on index
  def switch_study
    @index = Index.find(params['id'])
    date = create_date(params['date'])
    @index.switch_study!(date)
    render(:inline => "<%= redraw_student(@index) %>")
  end

  # supervise scholarship by faculty_secretary
  def supervise_scholarship_claim
    @index = Index.find(params[:id])
    @student = @index.student
    @student.update_attribute('scholarship_supervised_at', Time.now)
    render(:inline => "<%= redraw_student(@index) %>")
  end

  # renders time form for other actions
  def time_form
    @index = Index.find(params[:id])
    @form_url = {:action => params['form_action'], :id => params['id']}
    @form_url[:controller] = params['form_controller'] || 'students'
  end

  def confirm_approve
    @document = Index.find(params[:id])
    @document.approve_with(params[:statement])
    render(:partial => 'shared/confirm_approve')
  end

  # methods for editing personal details
  def edit_email
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
    @email = @index.student.email_or_new
  end

  def save_email
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @email = @index.student.email_or_new
    @email.update_attribute(:name, params[:email][:name])
  end

  def edit_display_name
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
    @display_name = @index.student.display_name
    @firstname = @index.student.firstname
    @lastname = @index.student.lastname
  end

  def save_display_name
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @student.update_attribute(:firstname, params[:student][:firstname])
    @student.update_attribute(:lastname, params[:student][:lastname])
  end

  def edit_phone
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
    @phone = @index.student.phone_or_new
  end
  
  def save_phone
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @phone = @index.student.phone_or_new
    @phone.update_attribute(:name, params[:phone][:name])
  end

  def edit_citizenship
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
  end
  
  def save_citizenship
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @student.update_attribute(:citizenship, params[:student][:citizenship])
  end

  def edit_tutor
    @index = Index.find(params[:id])
    @tutors = @index.coridor.tutors_for_select
  end

  def save_tutor
    @index = Index.find(params[:index][:id])
    @index.update_attribute(:tutor_id, params[:index][:tutor_id])
  end

  def edit_birthname
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
  end

  def save_birthname
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @student.update_attribute(:birthname, params[:student][:birthname])
  end

  def edit_consultant
    #@student = Student.find(params[:id], :include => :index)
    @index = Index.find(params[:id])
  end

  def save_consultant
    @index = Index.find(params[:index][:id])
    @index.update_attribute(:consultant, params[:index][:consultant])
  end

  def edit_account
    @student = Student.find(params[:id], :include => :index)
    @index = @student.index
  end
  
  def save_account
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    unless @index.update_attributes(params[:index])
      render_partial 'notsave_account'
    end  
  end
  # end of methods for editing personal details
 
  def pass
    @index = Index.find(params[:id])
    date = create_date(params[:date])
    if params[:what].to_sym == :final_exam
      @index.final_exam_passed!(date)
    else
      @index.disert_theme.defense_passed!(date)
    end
    render(:inline => "<%= redraw_student(@index) %>")
  end

  def method_missing(method_id, *arguments)
    if match = /pass_(.*)/.match(method_id.to_s)
      params[:what] = match[1]
      pass
    else
      super
    end
  end

  def end_study
  end

  def end_study_confirm
  @subject_end_study = params[:student][:subject_end_study]
  Notifications::deliver_end_study(@student,@subject_end_study)
  end

  private
  
  def create_date(date)
    if date['day']
      Date.civil(date['year'].to_i, date['month'].to_i, date['day'].to_i)
    else
      Date.civil(date['year'].to_i, date['month'].to_i)
    end
  end

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
      if !@user.person.indices.empty?
        @filters.concat([[_("my students"), 1], [_('my studying'), 4]])
      end
    end
    unless @user.has_one_of_roles?(['faculty_secretary', 'department_secretary'])
      # default filter to waiting for approvement 
      session[:filter] ||= 2 
    else
      session[:filter] ||= -1 
    end

  end

  def do_filter
    @filter = params[:filter_by] || session[:filter]
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
    session[:filter] = @filter
  end
end
