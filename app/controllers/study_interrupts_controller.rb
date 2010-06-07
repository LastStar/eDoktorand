class StudyInterruptsController < ApplicationController
  include LoginSystem
  layout 'employers'
  helper :students
  helper :study_plans
  before_filter :login_required, :prepare_student, :prepare_user

  def index
    unless @student
      @student = Index.find(params[:id]).student
    end
    @interrupt = @student.index.interrupts.build
  end

  def create
    @interrupt = StudyInterrupt.new(params[:interrupt])
    if @interrupt.plan_changed.to_i == 1
      session[:interrupt] = @interrupt
      redirect_to(:action => 'change', :controller => 'study_plans',
                  :id => @interrupt.index.student)
    else
      finish
    end
  end

  def finish
    @interrupt ||= session[:interrupt]
    @interrupt.save
    if @user.has_role?('student')
      Notifications::deliver_interrupt_alert(@interrupt.index.study_plan, @interrupt)
      redirect_to(:controller => 'study_interrupts', :action => 'print_interrupt',
                  :id => @interrupt.id)
    else
      if @user.has_role?('faculty_secretary')
        @interrupt.approve_like('dean', t(:message_0, :scope => [:txt, :controller, :interrupts]))
        @interrupt.index.interrupt!(@interrupt.start_on)
      end
      redirect_to(:controller => 'students')
    end
  end

  # confirms interrupt
  def confirm_approve
    @document = StudyInterrupt.find(params[:id])
    @document.approve_with(params[:statement])
    unless @document.index.study_plan.approved?
      @document.index.study_plan.approve_with(params[:statement])
    end
    if @user.has_role?('faculty_secretary')
      @document.index.interrupt!(@document.start_on)
    end
    
    if good_browser?
      render(:partial => 'shared/confirm_approve', 
             :locals => {:replace => 'interrupt_approval'})
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def confirm
    @index = Index.find(params[:id])
    @index.interrupt!(@index.interrupt.start_on)
    if good_browser?
      render(:partial => 'students/redraw_student')
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def end
    @index = Index.find(params[:id])
    @index.end_interrupt!(params[:date])
    if good_browser?
      render(:partial => 'students/redraw_student')
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def print_interrupt
    @interrupt = StudyInterrupt.find(params[:id])
  end  
end
