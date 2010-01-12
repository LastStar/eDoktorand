class FormController < ApplicationController
  include LoginSystem
  layout "employers"
  
  # page where candidate chooses desired coridor
  def index
    @faculties = Faculty.find(:all)
    @title = t(:message_0, :scope => [:txt, :controller, :form])
  end
  
  # login for edit or check candidate detail
  def login
    @candidate = Candidate.find(:first, :conditions => ["id = ?", params[:candidate][:id]])
    if @candidate && @candidate.hash == params[:candidate][:hash]
      @action = 'update'
      render :update do |page|
        if !@candidate.finished?
          page.replace_html  'main', :partial => 'shared/candidate_edit'
        else
          page.replace_html  'main', :partial => 'shared/candidate_detail'
        end
      end
    else
      render :update do |page|
        page.replace_html  'last', :inline => "<div id='error'>" + t(:message_15, :scope => [:txt, :controller, :form]) + "</div>"
        page.visual_effect :highlight, 'candidate_login'
      end    
    end    
  end
  
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = t(:message_1, :scope => [:txt, :controller, :form]) + @candidate.coridor.name
  end

  # preview what has been inserted
  def save()
      @candidate = Candidate.new(params[:candidate])
        if @candidate.save
          preview
          render(:action => :preview)
        else
          @title = t(:message_2, :scope => [:txt, :controller, :form])
          flash.now['error'] = t(:message_3, :scope => [:txt, :controller, :form])
          @action = 'save'
          render(:action => :details)
        end
  end

  # update candidate
  def update
    @candidate = Candidate.find(params[:candidate][:id])
    if @candidate.update_attributes(params[:candidate])
      preview
      render(:action => :preview)
    else
      @title = t(:message_4, :scope => [:txt, :controller, :form])
      flash.now['error'] = t(:message_5, :scope => [:txt, :controller, :form])
      @action = 'update'
      render(:action => :details)
    end
  end

  # preview information
  def preview
    if @candidate
      @title = t(:message_6, :scope => [:txt, :controller, :form])
      flash.now['notice'] = t(:message_7, :scope => [:txt, :controller, :form]) 
    else
      @candidate = Candidate.find(params[:id])
      @title = t(:message_8, :scope => [:txt, :controller, :form])
    end
  end

  # correct details
  def correct
    @candidate = Candidate.find(params[:id])
    flash.now['notice'] = t(:message_9, :scope => [:txt, :controller, :form])
    @action = 'update'
    @title = t(:message_10, :scope => [:txt, :controller, :form])
    render(:action => :details)
  end

  # finish submition
  def finish
    @candidate = Candidate.find(params[:id])
    @candidate.finish!
    @title = t(:message_11, :scope => [:txt, :controller, :form])
  end

  private
  # prepares candidate with some preloaded values
  def prepare_candidate
    @candidate = Candidate.new do |c| 
      c.coridor = Coridor.find(params[:id])
      c.state = 'CZ'
      c.address_state = 'CZ'
      c.university = t(:message_14, :scope => [:txt, :controller, :form])
      c.faculty = c.coridor.faculty.name
      language1_id = 1133 if c.admitting_faculty == 3
    end
  end

end
