class CoridorsController < ApplicationController
  include LoginSystem
  
  before_filter :prepare_user
  layout 'employers', :except => [:new, :create, :edit, :update, :destroy,
                                  :add_subject, :save_subject]

  def index
    list
    render :action => :list
  end

  def list
    @coridors = Coridor.accredited_for(@user)
  end

  def subjects
    @coridor = Coridor.find_by_id(params[:id])
    session[:coridor_id] = params[:id]
    @requisite_subjects = @coridor.requisite_subjects
    @voluntary_subjects = @coridor.voluntary_subjects
    @obligate_subjects = @coridor.obligate_subjects
  end
  
  def del_subject
    @coridor_subject_id = params[:id]
    CoridorSubject.find(params[:id]).destroy
  end
  
  def add_subject
    @coridor_subject = eval("%s.new(:coridor_id => %i)" % [params[:type], session[:coridor_id]])
    @subjects = Subject.find_for_coridor(session[:coridor_id], :not_taken => true)
  end

  def save_subject
    @coridor_subject = eval("%s.new(params[:coridor_subject])" % params[:coridor_subject][:type])
    @coridor_subject.coridor_id = session[:coridor_id]
    @coridor_subject.save
  end
  
  def destroy
    Coridor.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
