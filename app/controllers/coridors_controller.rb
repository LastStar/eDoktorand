class CoridorsController < ApplicationController
  include LoginSystem
  
  before_filter :prepare_user, :login_required, :except => [:invitation]
  layout 'employers', :except => [:index, :list, :show, :new, :create, :edit, :update, :destroy, :add_subject, :save_subject, :manage_edit]

  def index
    list
    render_action 'list'
  end

  def list
    @coridors = Coridor.find_all
  end

  def show
    @coridor = Coridor.find(params[:id])
  end

  def new
    @coridor = Coridor.new
  end

  def create
    @coridor = Coridor.new(params[:coridor])
    if @coridor.save
      flash['notice'] = 'Coridor was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @coridor = Coridor.find(params[:id])
  end

  def update
    @coridor = Coridor.find(params[:coridor][:id])
    if @coridor.update_attributes(params[:coridor])
      flash['notice'] = 'Coridor was successfully updated.'
      redirect_to :action => 'show', :id => @coridor.id
    else
      render_action 'edit'
    end
  end

  def manage_coridor
    person_id = @user.person_id
    person = Person.find(person_id)
    @coridors = Coridor.find_all_by_faculty_id(person.faculty.id)
  end

  def manage_edit
    @coridor = Coridor.find_by_id(params[:id])
    session[:coridor_id] = params[:id]
    @requisite_subjects = @coridor.requisite_subjects
    @voluntary_subjects = @coridor.voluntary_subjects
    @obligate_subjects = @coridor.obligate_subjects

  end
  
  def del_subject
    type = params[:type]
    subject = ''
    if type == 'VoluntarySubject'
      subject = VoluntarySubject.find(params[:id])
    end
    if type == 'ObligateSubject'
      subject = ObligateSubject.find(params[:id])
    end
    if type == 'RequisiteSubject'
      subject = RequisiteSubject.find(params[:id])
    end
    subject.destroy
    redirect_to :action => 'manage_edit', :id =>subject.coridor_id
  end
  
  def add_subject
#breakpoint
#@subjects = CoridorSubject.find(:all).collect {|p| [ p.subject.label, p.id ] }
#@subjects = CoridorSubject.find(:all, :include => :subject, :order => 'subjects.label').collect {|p| [ p.subject.label+' '+p.id.to_s, p.id ]}
#@subjects = Subject.find(:all,:order => 'label').collect {|p| [ p.label+' '+p.id.to_s, p.id ]}
    @type = params[:subject]
    coridor = Coridor.find_by_id(session[:coridor_id])
    subject_ids1 = coridor.obligate_subjects.collect { |p| p.subject.id}
    subject_ids2 = coridor.voluntary_subjects.collect { |p| p.subject.id}
    subject_ids3 = coridor.requisite_subjects.collect { |p| p.subject.id}
    subject_ids = subject_ids1 + subject_ids2 + subject_ids3
    @subjects = Subject.find(:all,:include => :coridor_subjects, :order => 'label', :conditions => ['coridor_subjects.subject_id not in (?)',subject_ids]).collect {|p| [ p.label, p.id ]}
  end

  def save_subject
    @type = params[:subject][:type]
    @coridor = session[:coridor_id]
      if @type == 'voluntary'
        @subject = VoluntarySubject.new()
        @subject.subject_id = params[:subject][:id]
        @subject.coridor_id = session[:coridor_id]
        @subject.save
     end
     if @type == 'obligate'
       @subject = ObligateSubject.new()
       @subject.subject_id = params[:subject][:id]
       @subject.coridor_id = session[:coridor_id]
       @subject.save
     end
     if @type == 'requisite'
       @subject = RequisiteSubject.new()
       @subject.subject_id = params[:subject][:id]
       @subject.coridor_id = session[:coridor_id]
       @subject.save
     end
  end
  
  def destroy
    Coridor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
