class StudentsController < ApplicationController
  include LoginSystem
  helper :study_plans
  layout 'employers',
        :except => [:edit_citizenship, :edit_display_name, :edit_phone,
                    :edit_email, :edit_birthname, :edit_consultant, :edit_tutor,
                    :edit_street, :edit_zip, :edit_city, :edit_desc_number,
                    :save_street, :save_city, :save_zip, :save_desc_number,
                    :edit_postal_street, :edit_postal_zip, :edit_postal_city,
                    :edit_postal_desc_number, :save_postal_street,
                    :save_postal_city, :save_postal_zip, :save_postal_desc_number,
                    :time_form, :filter, :list_xls, :edit_account,
                    :edit_specialization, :save_specialization, :save_department,
                    :edit_department]

  before_filter :login_required
  before_filter :set_title
  before_filter :prepare_order, :prepare_filter, :except => [:show, :contact]
  before_filter :prepare_conditions, :prepare_student

  # saves the street of address to db
  def save_postal_street
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:postal_street, params[:student][:postal_street])
  end

  # saves the city of address to db
  def save_postal_city
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:postal_city, params[:student][:postal_city])
  end

  # saves the zip of address to db
  def save_postal_zip
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:postal_zip, params[:student][:postal_zip])
  end

  # saves the description number of address to db
  def save_postal_desc_number
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:postal_desc_number, params[:student][:postal_desc_number])
  end

  def edit_postal_street
    @student = Student.find(params[:id])
  end

  def edit_postal_city
    @student = Student.find(params[:id])
  end

  def edit_postal_desc_number
    @student = Student.find(params[:id])
  end

  def edit_postal_zip
    @student = Student.find(params[:id])
  end

  # saves the street of address to db
  def save_street
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:street, params[:student][:street])
  end

  # saves the city of address to db
  def save_city
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:city, params[:student][:city])
  end

  # saves the zip of address to db
  def save_zip
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:zip, params[:student][:zip])
  end

  # saves the description number of address to db
  def save_desc_number
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:desc_number, params[:student][:desc_number])
  end

  def edit_street
    @student = Student.find(params[:id])
  end

  def edit_city
    @student = Student.find(params[:id])
  end

  def edit_desc_number
    @student = Student.find(params[:id])
  end

  def edit_zip
    @student = Student.find(params[:id])
  end

  # FIXME is this really needed?
  def save_address
    @student = Student.find(params[:student][:id])
    @student.update_attributes(params[:student])
  end

  def mail_list
    @indices = Index.find_for(@user, :order => 'people.lastname', :conditions => ['indices.finished_on is null'])
  end

  def admin_edit_mail
    @index = Index.find(params[:id])
    if @index.student.email != nil
      render :partial => "admin_edit_mail"
    else
      render :partial => "admin_create_mail"
    end
  end

  def admin_update_mail
    @index = Index.find(params[:index][:id])
    @index.update_attribute(:email, params[:student][:email])
    render :partial => "admin_show_mail"
  end

  # main page with students for employers
  def index
  end

  # renders xls file with curent filter
  def list_xls
    do_filter
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="excel-export.xls"'
    headers['Cache-Control'] = ''
  end

  # searches in students lastname
  def search
    @indices = Index.find_for(@user, :search => params[:search], :order => 'people.lastname')
    if @indices.size == 1
      @index = @indices.first
      render(:action => 'show')
    end
  end

  # filters students
  def filter
    do_filter
    render(:partial => 'list')
  end

  # multiple filtering
  def multiple_filter
    options = params.to_hash.symbolize_keys
    options[:user] = @user
    options[:order] = 'people.lastname'
    @indices = Index.find_by_criteria(options)
    render(:partial => 'list')
  end

  # renders student details
  def show
    @index = Index.find_with_all_included(params[:id])
    if @index.disert_theme.nil?
      @index.disert_theme = DisertTheme.create(:finishing_to => 6, :title => "doplnit", :index => @index)
    end
  end

  # finishes study
  def finish
    @index = Index.find(params[:id])
    date = params[:date]
    @index.finish!(Date.civil(date['year'].to_i, date['month'].to_i, date['day'].to_i))
    render(:partial => 'redraw_student')
  end


  # unfinishes study
  def unfinish
    @index = Index.find(params[:id])
    @index.unfinish!
    if good_browser?
      render(:partial => 'redraw_student')
    else
      render(:partial => 'redraw_list')
    end
  end

  # switches study on index
  def switch_study
    @index = Index.find(params['id'])
    date = create_date(params['date'])
    @index.switch_study!(date)
    if good_browser?
      render(:partial => 'redraw_student')
    else
      render(:partial => 'redraw_list')
    end
  end

  # approve scholarship by faculty_secretary
  def approve_scholarship_claim
    @index = Index.find(params[:id])
    @student = @index.student
    @index.approve_accommodation_scholarship!
    if good_browser?
      render(:partial => 'redraw_student')
    else
      render(:partial => 'redraw_list')
    end
  end

  # cancel scholarship by faculty_secretary
  def cancel_scholarship_claim
    @index = Index.find(params[:id])
    @student = @index.student
    @index.cancel_accommodation_scholarship!
    if good_browser?
      render(:partial => 'redraw_student')
    else
      render(:partial => 'redraw_list')
    end
  end

  # renders time form for other actions
  def time_form
    @index = Index.find(params[:id])
    @form_url = {:action => params['form_action'], :id => params['id']}
    @form_url[:controller] = params['form_controller'] || 'students'
    @date = params[:date] ? Time.parse(params[:date]) : Date.today
    @day = params[:day]
    @form_action = params[:form_action]
  end

  def confirm_approve
    @document = Index.find(params[:id])
    @document.approve_with(params[:statement])
    if good_browser?
      render(:partial => 'shared/confirm_approve')
    else
      render(:partial => 'redraw_list')
    end
  end

  # methods for editing personal details
  def edit_email
    @student = Student.find(params[:id])
  end

  def save_email
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:email, params[:student][:email])
  end

  def edit_phone
    @student = Student.find(params[:id])
  end

  def save_phone
    @student = Student.find(params[:student][:id])
    @student.update_attribute(:phone, params[:student][:phone])
  end

  # TODO cleanup this mess vvvvvvvv
  def edit_display_name
    @student = Student.find(params[:id], :include => :index)
    @titles = Title.find(:all, :order => "label").collect {|p| [ p.label, p.id ] }
    @index = @student.index
    @display_name = @index.student.display_name
    @firstname = @index.student.firstname
    @lastname = @index.student.lastname
    @title_before_id = @index.student.title_before_id
    @title_after_id = @index.student.title_after_id
  end

  def save_display_name
    @student = Student.find(params[:student][:id], :include => :index)
    @index = @student.index
    @student.update_attributes(params[:student])
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

  def edit_department
    @index = Index.find(params[:id])
    @departments = @index.faculty.departments
  end

  def save_department
    @index = Index.find(params[:index][:id])
    @index.update_attributes(:department_id => params[:index][:department_id])
  end

  def edit_specialization
    @index = Index.find(params[:id])
    @specializations = @index.faculty.specializations
  end

  def save_specialization
    @index = Index.find(params[:index][:id])
    @index.update_attributes(:specialization_id => params[:index][:specialization_id])
  end

  def edit_tutor
    @index = Index.find(params[:id])
    @tutors = @index.specialization.tutors_for_select
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
      render(:partial => 'notsave_account')
    end
  end
  # end of methods for editing personal details

  #TO DO: THIS METHOD MAYBE UNUSED NOW - NEED TO CHECK!
  def pass
    @index = Index.find(params[:id])
    date = create_date(params[:date])
    if params[:what].to_sym == :final_exam
    #if params[:what] == "pass_final_exam"
      @index.final_exam_passed!(date)
    else
      @index.disert_theme.defense_passed!(date)
    end
    render(:partial => 'redraw_student')
  end

  def method_missing(method_id, *arguments)
    if match = /passt(:message_0, :scope => [:controller, :students])/.match(method_id.to_s)
      params[:what] = match[1]
      pass
    else
      super
    end
  end

  def end_study
  end

  def change_tutor
  end

  def end_study_confirm
    @end_study_subject = params[:end_study_subject]
    Notifications::deliver_end_study(@student, @end_study_subject)
  end

  def change_tutor_confirm
    @subject_change = params[:subject_change]
    if I18n.locale.to_s == "cs"
      Notifications::deliver_change_tutor_cs(@student, @subject_change)
    else
      Notifications::deliver_change_tutor_en(@student, @subject_change)
    end
  end

  def individual_protocol
    @index = Index.find(params[:id])
  end

  def claimed_individual
    @index = Index.find(params[:id])
  end

  def decide_individual
    @index = Index.find(params[:id])
    if params['commit'] == t(:approve, :scope => [:view])
      @index.approve_individual!
    else
      @index.cancel_individual!
    end
    redirect_to :action => :individual_protocol, :id => @index.id
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
    @title = t(:message_1, :scope => [:controller, :students])
  end

  # prepares order variable for listin
  # TODO create some better mechanism to do ordering
  def prepare_order
    @order = 'people.lastname, people.firstname, study_plans.created_on, study_interrupts.created_on'
  end

  # prepares filter variable
  # FIXME this is a mess vvvvv
  def prepare_filter
    @filters = [[t(:message_2, :scope => [:controller, :students]), 2], [t(:message_3, :scope => [:controller, :students]), 0],
      [t(:message_4, :scope => [:controller, :students]), 3]]
    if (@user.has_one_of_roles?(['leader', 'dean', 'vicerector']))
      if !@user.person.indices.empty?
        @filters.concat([[t(:message_5, :scope => [:controller, :students]), 1], [t(:message_6, :scope => [:controller, :students]), 4]])
      end
    end
    if @user.has_role?('board_chairman')
      @filters.concat([[t(:chairmaned, :scope => [:controller, :students]), 5]])
    end
    if !@user.has_one_of_roles?(['faculty_secretary', 'department_secretary', 'university_secretary'])
      # default filter to waiting for approval
      session[:filter] ||= 2
    else
      session[:filter] ||= 3
    end
  end

  # filtering students by user and filter
  def do_filter
    @filter = params[:id] || session[:filter]
    case @filter.to_i
    when 5
      @indices = Index.chairmaned_by(@user)
    when 4
      @indices = Index.find_tutored_by(@user, :unfinished => true)
    when 3
      @indices = Index.find_studying_for(@user)
    when 2
      @indices = Index.find_waiting_for_statement(@user)
    when 1
      @indices = Index.find_tutored_by(@user, :order => @order)
    when 0
      @indices = Index.find_for(@user, :order => @order)
    end
    session[:filter] = @filter
  end
end
