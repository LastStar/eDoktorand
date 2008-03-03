class StudyPlansController < ApplicationController
  include LoginSystem
  helper :students
  layout 'employers', :except => [:add_en, :save_en, :show]
  before_filter :login_required, :prepare_user, :prepare_student

  # shows student basic information
  def index
    @title = _("Study plan")
    @index = @student.index
    @voluntary_subjects = @index.coridor.voluntary_subjects 
  end

  # shows student detail
  def show
    @index = Index.find(params[:id])
  end

  # starts the study plan creating process
  def create
    prepare_plan_session
    @title = _("Creating study plan")
    if ObligateSubject.has_for_coridor?(@student.coridor)
      @type = 'obligate'
    elsif SeminarSubject.has_for_coridor?(@student.coridor)
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
      flash[:error] = _('subjects have to be different')
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
    @title = _("Creating study plan")
    @requisite_subjects = PlanSubject.create_for(@student, :requisite)
    @subjects = CoridorSubject.for_select(:coridor => @student.index.coridor)
    @study_plan = @student.index.prepare_study_plan
    @plan_subjects = []
    (@student.coridor.voluntary_amount + 8).times do |i|
      (plan_subject = PlanSubject.new('subject_id' => -1)).id = (i + 1)
      @plan_subjects << plan_subject
    end
    @disert_theme = @student.index.build_disert_theme
  end

  # renders change page for study plan
  def change
    @title = _('Change of study plan')
    if !@student
      @student = Student.find(params[:id])
    end
    coridor = @student.index.coridor
    @subjects = CoridorSubject.for_select(:coridor => coridor)
    if @study_plan = @student.index.study_plan
      if session[:change_back] && session[:change_back] == 1
        @plan_subjects = session[:voluntary_subjects]
        session[:change_back] = 0
      else
        @plan_subjects = @study_plan.unfinished_subjects
      end
      (@student.coridor.voluntary_amount - @plan_subjects.size + 4).times do |i|
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
  def save_full
    @errors = []
    extract_voluntary
    if !extract_voluntary || !@errors.empty?
      flash[:errors] = @errors.uniq
      session[:change_back] = 1
      redirect_to(:action => 'change', :id => params[:student][:id])
    else
      @student = Student.find(params[:student][:id])
      if @student.study_plan && @student.study_plan.atestation
        @atestation = @student.study_plan.atestation 
      end
      unless session[:voluntary_subjects].map {|ps| ps.subject_id}.uniq.size <= session[:voluntary_subjects].size
        @errors << _("subjects have to be different")     
      end
      @study_plan = StudyPlan.new(params[:study_plan])
      @study_plan.plan_subjects = reindex_plan_subjects(session[:voluntary_subjects])
      if session[:finished_subjects]
        session[:finished_subjects].each do |sub|
          @study_plan.plan_subjects << sub.clone 
        end 
      end
      @disert_theme = DisertTheme.new(params[:disert_theme])
      @disert_theme.index = @student.index
      @study_plan.admited_on = Time.now
      @study_plan.index = @student.index
      if @study_plan.valid? && @disert_theme.valid? && @errors.empty?
        @study_plan.save
        @atestation.update_attribute(:document_id, @study_plan.id) if @atestation
        @disert_theme.save
        if @user.person.is_a?(Student)
          if session[:interupt]
            redirect_to :controller => 'interupts', :action => 'finish'
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

  # atests study plan 
  def atest
    @study_plan = StudyPlan.find(params[:id])
  end

  # confirms and saves statement
  def confirm_atest
    @document = StudyPlan.find(params[:id])
    @document.atest_with(params[:statement])
    if good_browser?
      render(:partial => 'shared/confirm_approve', 
            :locals => {:replace => 'atestation',
                        :approvement => study_plan.atestation})
    else
      render(:partial => 'students/redraw_list')
    end
  end

  # prepares form for atestation details
  def atestation_details
    @study_plan = @student.study_plan
    @atestation_detail = @study_plan.next_atestation_detail_or_new
  end

  # saves atestation detail 
  def save_atestation_detail
    if params[:atestation_detail][:id] == ''
      @atestation_detail = \
        AtestationDetail.create(params[:atestation_detail])
    else
      @atestation_detail = \
        AtestationDetail.find(params[:atestation_detail][:id])
      @atestation_detail.update_attributes(params[:atestation_detail])
    end
  end

  #adding only final_areas en (fixing bug)
  def add_en
    @id = Index.find(params[:id])
    @final_area_id = params[:final_area_id]
  end

  #saving only final_areas en (fixing bug)
  def save_en
    @id = Index.find(params[:id])
    @study_plan = @id.study_plan
    @final_area_id = params[:final_area_id]
    @study_plan.final_areas['en'][params[:final_area_id]] = params[:en_title]
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
    if RequisiteSubject.has_for_coridor?(@student.coridor)
      session[:requisite_subjects] = PlanSubject.create_for(@student, :requisite)
    end
    if ObligateSubject.has_for_coridor?(@student.coridor)
      session[:obligate_subjects] = PlanSubject.create_for(@student, :obligate)
    end
    if SeminarSubject.has_for_coridor?(@student.coridor)
      session[:seminar_subjects] = PlanSubject.create_for(@student, :seminar)
    end
    session[:voluntary_subjects] = PlanSubject.create_for(@student.index, :voluntary)
    session[:language_subjects] = PlanSubject.create_for(@student.index.coridor, :language)
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
          @errors << _('some external subject is invalid')
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
      @errors << _("subjects have to be different")
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
    if session[:language_subjects].map {|ps| ps.subject_id}.uniq.size != 2
      flash.now[:error] = _("languages have to be different")
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
      flash.now[:error] = _('seminar subjects have to be different')
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
