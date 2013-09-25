require 'will_paginate'

class CandidatesController < ApplicationController
  include LoginSystem
  layout 'employers', :except => [:delete_all, :destroy_all]

  before_filter :login_required, :except => [:invitation]
  before_filter :prepare_user
  before_filter :prepare_faculty
  before_filter :set_title
  before_filter :prepare_sort, :only => [:list, :list_all, :list_admission_ready , :index]


  # lists all candidates
  def index
    if @user.has_role?('board_chairman')
      redirect_to :action => 'list_admission_ready', :specialization => @user.person.tutorship.specialization_id
    else
      list
      render(:action => 'list')
    end
  end

  # lists all candidates
  def list
    session[:list_mode] = 'list'
    @backward = false
    session[:candidate_filter] = params[:filter] if params[:filter]
    @filtered_by = session[:candidate_filter]
    session[:back_page] = 'list'
    conditions = Candidate.prepare_conditions(session[:candidate_filter], @faculty, @user, params[:specialization])
    @candidates = Candidate.paginate :page => params[:page],
                                     :per_page => 13,
                                     :order => session[:category],
                                     :conditions => conditions
    session[:current_page_backward] = params[:page]
  end

  # lists all candidates ordered by category
  def list_all
    session[:list_mode] = 'list_all'
    @backward = true
    session[:back_page] = 'list_all'
    @candidates = Candidate.find_all_finished_by_session_category(params, @faculty, session[:category], @user)
    session[:current_page_backward_all] = session[:category]
    render(:action => 'list')
  end

  def set_foreign_payer
    @candidate = Candidate.find(params[:id])
    @candidate.toggle_foreign_pay
    render :inline => "<%= foreign_pay_link(@candidate) %>"
  end

  def set_no_foreign_payer
    candidate = Candidate.find(params[:id])
    candidate.update_attribute(:foreign_pay,false)
    #render :inline => "<%= link_to_remote('set foreign payer', :url => { :action => 'set_foreign_payer', :id => candidate.id}, :method => :get, :update => 'foreign#{candidate.id}')"
  end

  def destroy_all
    candidates = Candidate.finished_before(TermsCalculator.this_year_start).from_faculty(@user.person.faculty)
    candidates.each {|c| c.destroy}
    flash[:notice] = t(:message_11, :scope => [:controller, :candidates]) % candidates.size
    redirect_to :action => :list
  end

  # lists all candidates ordered by category
  def list_admission_ready
     if params[:specialization]
       session[:list_admission_ready] = params[:specialization]
     end
    session[:list_mode] = 'list'
    @filtered_by = params[:category]
    @candidates = Specialization.find(session[:list_admission_ready]).approved_candidates.paginate :page => params[:page], :per_page => 7, :order => session[:category]
    render(:action => :list)
  end

  # shows candidate details
  def show
    @candidate = Candidate.find(params[:id])
  end

  # edits candidate
  def edit
    @candidate = Candidate.find(params[:id])
    @action = 'update'
  end

  # updates candidate
  def update
    @candidate = Candidate.find(params[:candidate][:id])
    if @candidate.update_attributes(params[:candidate])
      flash[:notice] = t(:message_0, :scope => [:controller, :candidates])
      redirect_to :action => 'show', :id => @candidate.id
    else
      render(:action => :edit)
    end
  end

  # destroys candidate
  def destroy
    Candidate.find(params[:id]).destroy
    if session[:back_page] == 'list'
      redirect_to :action => 'list', :page => session[:current_page_backward]
    else
      redirect_to :action => 'list_all'
    end

  end

  # delete candidate
  def delete
    Candidate.find(params[:id]).unfinish!
      if session[:back_page] == 'list'
        redirect_to :action => 'list', :page => session[:current_page_backward]
      else
        redirect_to :action => 'list_all'
      end
  end

  def admit_for_revocation
    candidate = Candidate.find(params[:id])
    candidate.delete_reject!
    candidate.admit!
      if session[:back_page] == 'list'
        redirect_to :action => 'list', :page => session[:current_page_backward]
      else
        redirect_to :action => 'list_all'
      end
  end

  # enroll candidate form
  def enroll
    @candidate = Candidate.find(params[:id])
    @enrolled_on = if (date = Parameter.get('enroll_date', @user.person.faculty)).present?
      Date.parse(date)
    else
      Date.today
    end
		@student = @candidate.enroll!(@enrolled_on, @enrolled_on)
  end

	# confirms enrollment of candidate and sends email
  def confirm_enroll
    @candidate = Candidate.find(params[:id])
    # Notifications::deliver_admit_candidate(@candidate)
    @candidate.enroll!
    if !params[:user][:login].empty?
      @user = User.new(params[:user])
      @user.person = @candidate.student
      @user.roles << Role.find_by_name('student')
      @user.person.index = Index.create('tutor_id' => @candidate.tutor_id,
      'department_id' => @candidate.department_id, 'study_id' => @candidate.study_id,
      'specialization_id' => @candidate.specialization_id)
      if !@user.save
        render(:action => :enroll)
      else
        redirect_to :action => 'list'
      end
    end
  end

  # amits candidate form
  def admit
    @candidate = Candidate.find(params[:id])
  end

  # confirms admittance of candidate and sends email
  def confirm_admit
    session[:conditional] = nil
    if(params[:admit_id] == '0')
      redirect_to(:action => 'reject', :id => params[:id])
    else
      session[:conditional] = @conditional = true if params[:admit_id] == '2'
      @candidate = Candidate.find(params[:id])
      I18n.locale = @candidate.specialization.locale || "cz"
      @candidate.update_attributes(params[:candidate])
    end
  end

  # action for remote link that admit candidate
  def admit_now
    @candidate = Candidate.find(params[:id])
    if params[:mail] != 'no mail'
      Notifications::deliver_admit_candidate(@candidate, session[:conditional])
    end
    @candidate.admit!
    if params[:mail] != 'no mail'
      render(:text => t(:message_1, :scope => [:controller, :candidates]))
    else
      render(:text => t(:message_2, :scope => [:controller, :candidates]))
    end
  end

  # finishes admittance
  def admittance
     @candidate = Candidate.find(params[:id])
  end

  # set candidate ready for invitation
  def ready
    candidate = Candidate.find(params[:id])
    candidate.ready!
    flash['notice'] = t(:message_3, :scope => [:controller, :candidates]) + candidate.display_name + t(:message_4, :scope => [:controller, :candidates])
    if session[:back_page] == 'list'
      redirect_to :action => 'list', :page => session[:current_page_backward]
    else
      redirect_to :action => 'list_all'
    end
  end

  # set candidate ready for admition
  def invite
    @candidate = Candidate.find(params[:id])
    I18n.locale = @candidate.specialization.locale || "cz"
    render(:action => :invitation)
  end

	# action for remote link that invite candidate
  def invite_now
    @candidate = Candidate.find(params[:id])
    @candidate.invite!
    Notifications::deliver_invite_candidate(@candidate, @faculty, Time.now)
    render(:text => t(:message_5, :scope => [:controller, :candidates]))
  end

  # shows invitation for candidate
  def invitation
   @candidate = Candidate.find(params[:id])
  end

  # rejects candidate from study
  def reject
    @candidate = Candidate.find(params[:id])
    I18n.locale = @candidate.specialization.locale || "cz"
  end

  # action for remote link that reject candidate
  def reject_now
    @candidate = Candidate.find(params[:id])
    @candidate.reject!
		Notifications::deliver_reject_candidate(@candidate)
    render(:text => t(:message_6, :scope => [:controller, :candidates]))
  end

  # summary method for candidates
  def summary
    faculty = Faculty.find(@user.person.faculty.id)
    if params[:id] == "department" || params[:id].empty?
       @departments = faculty.departments
     else
       @corridors = faculty.specializations
    end
  end

  private

  # sets title of the controller
  def set_title
    @title = t(:message_7, :scope => [:controller, :candidates])
    WillPaginate::ViewHelpers.pagination_options[:previous_label] = "&laquo; %s" % t(:message_8, :scope => [:controller, :candidates])
    WillPaginate::ViewHelpers.pagination_options[:next_label] = "%s &raquo;" % t(:message_9, :scope => [:controller, :candidates])
  end

  def prepare_sort
      if params[:category]
        if params[:category] != session[:category]
          session[:order] = ''
        else if params[:page] == nil
             session[:order] = session[:order] == ' desc' ? '' : ' desc'
            end
        end
        session[:category] = params[:category]
        if params[:page] == nil
          session[:category] << session[:order]
        end
      end
  end

  # parses date from select_date helper
  def parse_date(date)
    return Date.new(date['year'].to_i, date['month'].to_i, date['day'].to_i)
  end
end
