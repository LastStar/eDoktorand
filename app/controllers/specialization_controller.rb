class SpecializationsController < ApplicationController
  include LoginSystem
  
  before_filter :login_required
  before_filter :prepare_user
  layout 'employers', :except => [:new, :create, :edit, :update, :destroy,
                                  :add_subject, :save_subject]

  def index
    list
    render :action => :list
  end

  def list
    @specializations = Specialization.accredited_for(@user)
  end

  def attestation
    @indices = Index.find_for(@user, :unfinished => true, :not_interrupted => true,
                              :conditions => ["specialization_id = ?", params[:id]],
                              :order => "people.lastname")

  end

  def subjects
    @specialization = Specialization.find_by_id(params[:id])
    session[:specialization_id] = params[:id]
    @requisite_subjects = @specialization.requisite_subjects
    @voluntary_subjects = @specialization.voluntary_subjects
    @obligate_subjects = @specialization.obligate_subjects
  end
  
  def del_subject
    @specialization_subject_id = params[:id]
    SpecializationSubject.find(params[:id]).destroy
  end
  
  def add_subject
    @specialization_subject = eval("%s.new(:specialization_id => %i)" % [params[:type], session[:specialization_id]])
    @subjects = Subject.find_for_specialization(session[:specialization_id], :not_taken => true)
  end

  def save_specialization_subject
    @specialization_subject = eval("%s.new(params[:specialization_subject])" % params[:specialization_subject][:type])
    @specialization_subject.specialization_id = session[:specialization_id]
    @specialization_subject.save
  end
  
end
