require 'soap/netHttpClient'
class StudyPlansController < ApplicationController
  include LoginSystem
  helper :students
  layout 'employers', :except => [:add_en, :save_en, :show, :add_cz, :save_cz]
  before_filter :login_required, :prepare_user, :prepare_student
  CARD_SERVICE = 'http://193.84.33.16:80/axis2/services/GetCardStateService/getCardStateByUIC?uic=%i'

  # shows result of student requests
  def requests
    client = SOAP::NetHttpClient.new
    begin
      @card_request = Hash.from_xml(client.get_content(CARD_SERVICE % @student.uic))['getCardStateByUICResponse']['cardState']['NAZEV']
    rescue
      @card_request = t(:message_10, :scope => [:txt, :controller, :plans])
    end
  end

  # shows student basic information
  def index
    @title = t(:message_0, :scope => [:txt, :controller, :plans])
    @index = @student.index
    @voluntary_subjects = @index.specialization.voluntary_subjects 
  end

  # shows student detail
  def show
    @index = Index.find(params[:id])
  end

  # starts the study plan creating process
  def create
    prepare_plan_session
    @title = t(:message_1, :scope => [:txt, :controller, :plans])
    if ObligateSubject.has_for_specialization?(@student.specialization)
      @type = 'obligate'
    elsif SeminarSubject.has_for_specialization?(@student.specialization)
      @type = 'seminar'
    else
      @type = 'voluntary'
    end
  end

  # saves obligate subjects to session
  # and creates voluntary subjects
  def save_obligate
    @created_subjects = []
    if params[:study_plan]
      session[:study_plan].attributes = params[:study_plan]
    end
    extract_obligate
    @created_subjects = session[:obligate_subjects]
    @type = 'voluntary'
    session[:return_to] = 'obligate'
  end

  # saves seminar subjects to session 
  # and creates voluntary subjects
  def save_seminar
    if extract_seminar
      flash[:error] = t(:message_2, :scope => [:txt, :controller, :plans])
      render(:partial => 'not_valid_seminar')
    else
      @created_subjects = session[:seminar_subjects]
      @type = 'voluntary'
      session[:return_to] = 'seminar'
      render(:action => :save_obligate)
    end
  end

  # saves voluntary subjects to session and prepares disert theme
  def save_voluntary
    @errors = []
    if !extract_voluntary || !@errors.empty?
      flash[:errors] = @errors.uniq
      render(:partial => 'not_valid_voluntarys')
    elsif params[:return] == '1'
      render(:partial => "not_valid_%s" % session[:return_to]) 
    end
  end

  # saves language subjects to session and creates voluntary subjects
  def save_language
    if extract_language
      render(:partial => 'not_valid_voluntarys') if params[:return] == '1'
    else
      render(:partial => 'not_valid_languages')  
    end
  end

  # saves disert theme to session
  def save_disert
    session[:study_plan].attributes = params[:study_plan]
    session[:study_plan].index = @student.index
    session[:disert_theme].attributes = params[:disert_theme]
    if !session[:disert_theme].valid?
      render(:partial => 'not_valid_disert') 
    elsif params[:return] == '1'
      render(:partial => 'not_valid_languages')
    end
  end

  # confirms study plan 
  def confirm
    @study_plan = session[:study_plan]
    @study_plan.admited_on = Time.now
    @study_plan.plan_subjects = concat_plan_subjects
    @study_plan.index_id = @student.index.id
    disert_theme = session[:disert_theme]
    disert_theme.index = @study_plan.index 
    disert_theme.save
    Notifications::deliver_study_plan_create(@study_plan)
    @study_plan.save
    reset_plan_session
    redirect_to :action => 'index'
  end

  # create study plan like no-student 
  def create_by_other 
    @student = Student.find(params[:id])
    @title = t(:message_3, :scope => [:txt, :controller, :plans])
    @requisite_subjects = PlanSubject.create_for(@student, :requisite)
    @subjects = SpecializationSubject.for_select(:specialization => @student.index.specialization)
    @study_plan = @student.index.prepare_study_plan
    @plan_subjects = []
    (@student.specialization.voluntary_amount + 8).times do |i|
      (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i + 1)
      @plan_subjects << plan_subject
    end
    @disert_theme = @student.index.build_disert_theme
  end

  # renders change page for study plan
  def change
    @title = t(:message_4, :scope => [:txt, :controller, :plans])
    @student ||= Student.find(params[:id])
    specialization = @student.index.specialization
    @subjects = SpecializationSubject.for_select(:specialization => specialization)
    if @study_plan = @student.index.study_plan
      if session[:change_back] && session[:change_back] == 1
        @plan_subjects = session[:voluntary_subjects]
        session[:change_back] = 0
      else
        @plan_subjects = @study_plan.unfinished_subjects
      end
      (@student.specialization.voluntary_amount - @plan_subjects.size + 4).times do |i|
        (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i+1)
        @plan_subjects << plan_subject
      end
      session[:finished_subjects] = @student.index.study_plan.finished_subjects
      @disert_theme = @student.index.disert_theme
    else
      create_by_other
    end
    render(:action => 'create_by_other')
  end

  # saves full form
  #FIXME too fat method
  def save_full
    @errors = []
    extract_voluntary
    new_approval = nil
    if !extract_voluntary || !@errors.empty?
      flash[:errors] = @errors.uniq
      session[:change_back] = 1
      redirect_to(:action => 'change', :id => params[:student][:id])
    else
      @student = Student.find(params[:student][:id])
      if @student.study_plan && @student.study_plan.attestation
        @attestation = @student.study_plan.attestation 
        @approval = @student.study_plan.approval
      end
      unless session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size <= session[:voluntary_subjects].size
        @errors << t(:message_5, :scope => [:txt, :controller, :plans])     
      end
      @study_plan = StudyPlan.new(params[:study_plan])
      @study_plan.plan_subjects = reindex_plan_subjects(session[:voluntary_subjects])
      if session[:finished_subjects]
        session[:finished_subjects].each do |sub|
          @study_plan.plan_subjects << sub.clone 
        end 
      end
      if (params[:url][:action] == "change") && @approval
        new_approval = @approval.clone
      end
      @disert_theme = DisertTheme.new(params[:disert_theme])
      @disert_theme.index = @student.index
      @study_plan.admited_on = Time.now
      @study_plan.index = @student.index
      if @study_plan.valid? && @disert_theme.valid? && @errors.empty?
        @study_plan.save
        if params[:url][:action] == "change" && new_approval && @user.has_one_of_roles?(['faculty_secretary','vicerector'])
          new_approval.document_id = @study_plan.id
          @study_plan.update_attribute(:approved_on,Time.now)
          new_approval.save
        end
        @attestation.update_attribute(:document_id, @study_plan.id) if @attestation
        @disert_theme.save
        if @user.person.is_a?(Student)
          if session[:interrupt]
            redirect_to :controller => 'study_interrupts', :action => 'finish'
          else
            redirect_to :controller => 'study_plans'
          end
        else
          redirect_to :controller => 'students'
        end
      else
        redirect_to :action => 'create_by_other', :id => params[:student][:id]
      end
    end
  end

  # confirms and saves statement
  def confirm_approve
    @document = StudyPlan.find(params[:id])
    @document.approve_with(params[:statement])
    if good_browser?
      render(:partial => 'shared/confirm_approve')
    else
      render(:partial => 'students/redraw_list')
    end
  end

  # attests study plan 
  def attest
    @study_plan = StudyPlan.find(params[:id])
  end

  # confirms and saves statement
  def confirm_attest
    @document = StudyPlan.find(params[:id])
    @document.attest_with(params[:statement])
    if good_browser?
      render(:partial => 'shared/confirm_approve', 
            :locals => {:replace => 'attestation',
                        :approval => @document.attestation,
                        :title => I18n::t(:message_12, :scope => [:txt, :view, :shared, :_study_detail, :rhtml])})
    else
      render(:partial => 'students/redraw_list')
    end
  end

  # prepares form for attestation details
  def attestation_details
    @study_plan = @student.study_plan
    @attestation_detail = @study_plan.next_attestation_detail_or_new
  end

  # saves attestation detail 
  def save_attestation_detail
    if params[:attestation_detail][:id] == ''
      @attestation_detail = \
        AttestationDetail.create(params[:attestation_detail])
    else
      @attestation_detail = \
        AttestationDetail.find(params[:attestation_detail][:id])
      @attestation_detail.update_attributes(params[:attestation_detail])
    end
  end

  #adding only final_areas en (fixing bug)
  def add_en
    @id = Index.find(params[:id])
    @final_area_id = params[:final_area_id]
    @value = ""
    @value = params[:final_area_value] if params[:final_area_value]
  end

  def add_cz
    @id = Index.find(params[:id])
    @final_area_id = params[:final_area_id]
    @value = ""
    @value = params[:final_area_value] if params[:final_area_value]
  end

  #saving only final_areas en (fixing bug)
  def save_en
    @index = Index.find(params[:id])
    @study_plan = @index.study_plan
    @final_area_id = params[:final_area_id]
    cz_array_areas = @study_plan.final_areas['cz']
    en_array_areas = @study_plan.final_areas['en']
    #MUST BE THERE for update column in DB - features or bug in rails 2.1?
    @study_plan.final_areas_will_change!
    en_array_areas.update("#{params[:final_area_id]}" => params[:en_title])
    full_array_areas = {"cz" => cz_array_areas, "en" => en_array_areas}
    @study_plan.final_areas = full_array_areas
    @study_plan.save
  end

  #saving only final_areas cz (fixing bug)
  def save_cz
    @id = Index.find(params[:id])
    @study_plan = @id.study_plan
    @final_area_id = params[:final_area_id]
    cz_array_areas = @study_plan.final_areas['cz']
    en_array_areas = @study_plan.final_areas['en']
    #MUST BE THERE for update column in DB - features or bug in rails 2.1?
    @study_plan.final_areas_will_change!
    cz_array_areas.update("#{params[:final_area_id]}" => params[:cz_title])
    full_array_areas = {"cz" => cz_array_areas, "en" => en_array_areas}
    @study_plan.final_areas = full_array_areas
    @study_plan.save
  end

  private
  def reset_plan_session
    session[:study_plan] = nil
    session[:disert_theme] = nil
    session[:last_semester] = nil
  end

  # prepare variables used in creation form
  def prepare_plan_session
    session[:study_plan] = @study_plan = @student.index.build_study_plan
    session[:disert_theme] = @student.index.build_disert_theme
    session[:last_semester] = 0
    # TODO do all in one step through model method
    if RequisiteSubject.has_for_specialization?(@student.specialization)
      session[:requisite_subjects] = PlanSubject.create_for(@student, :requisite)
    end
    if ObligateSubject.has_for_specialization?(@student.specialization)
      session[:obligate_subjects] = PlanSubject.create_for(@student, :obligate)
    end
    if SeminarSubject.has_for_specialization?(@student.specialization)
      session[:seminar_subjects] = PlanSubject.create_for(@student, :seminar)
    end
    session[:voluntary_subjects] = PlanSubject.create_for(@student.index, :voluntary)
    session[:language_subjects] = PlanSubject.create_for(@student.index.specialization, :language)
  end

  # controls last semester
  def last_semester(semester)
    session[:last_semester] ||= 0
    if session[:last_semester] < semester.to_i
      session[:last_semester] = semester.to_i   
    end
  end

  def extract_obligate
    session[:obligate_subjects] = []
    params[:plan_subject].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id
      last_semester(ps['finishing_on'])
      session[:obligate_subjects] << plan_subject
    end
  end

  def extract_voluntary
    external = 0
    session[:voluntary_subjects] = []
    params[:plan_subject].each do |id, ps|
      next if ps['subject_id'] == '-1'
      if ps['subject_id'] == '0' 
        external += 1
        subject = ExternalSubject.new(:label => ps['label'],
                                      :label_en => ps['label_en'])
        esd = subject.build_external_subject_detail(params[:external_subject_detail][id])
        subject.external_subject_detail = esd
        if !subject.valid? || !subject.external_subject_detail.valid?
          @errors << t(:message_6, :scope => [:txt, :controller, :plans])
        else
          subject.save
          esd.save
        end
      else
        subject = Subject.find(ps['subject_id'])
      end
      plan_subject = PlanSubject.new
      plan_subject.finishing_on = ps['finishing_on']
      plan_subject.subject = subject
      plan_subject.id = id
      session[:voluntary_subjects] << plan_subject
    end
    uniq = session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size 
    external = external == 0 ? 0 : external - 1
    if uniq < session[:voluntary_subjects].size - external 
      @errors << t(:message_7, :scope => [:txt, :controller, :plans])
    else
      session[:voluntary_subjects].each {|ps| last_semester(ps.finishing_on)}
    end
  end

  def extract_language
    session[:language_subjects] = []
    params[:plan_subject].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id
      last_semester(ps['finishing_on'])
      session[:language_subjects] << plan_subject
    end
    n = @student.faculty == Faculty.find(14) ? 1 : 2
    if session[:language_subjects].map {|ps| ps.subject_id}.uniq.size != n
      flash.now[:error] = t(:message_8, :scope => [:txt, :controller, :plans])
      false
    else
      true
    end
  end

  def extract_seminar
    session[:seminar_subjects] = []
    params[:plan_subject].each do |id, ps|
      plan_subject = PlanSubject.new(ps)
      plan_subject.id = id
      last_semester(ps['finishing_on'])
      session[:seminar_subjects] << plan_subject
    end
    if session[:seminar_subjects].map {|ps| ps.subject_id}.uniq.size != 2
      flash.now[:error] = t(:message_9, :scope => [:txt, :controller, :plans])
    end
  end

  def concat_plan_subjects(reindex = true)
    plan_subjects = []
    plan_subjects.concat(session[:voluntary_subjects])
    plan_subjects.concat(session[:language_subjects])
    if session[:requisite_subjects]
      plan_subjects.concat(session[:requisite_subjects]) 
    end
    if session[:seminar_subjects]
      plan_subjects.concat(session[:seminar_subjects]) 
    end
    if session[:obligate_subjects]
      plan_subjects.concat(session[:obligate_subjects]) 
    end
    if reindex
      reindex_plan_subjects(plan_subjects)
    else
      plan_subjects
    end
  end

  def reindex_plan_subjects(plan_subjects)
    plan_subjects.map do |ps|
      PlanSubject.new(ps.attributes)
    end
  end
end
