class InteruptsController < ApplicationController
  include LoginSystem
  layout 'employers'
  helper :students
  helper :study_plans
  before_filter :login_required, :prepare_student, :prepare_user

  def index
    unless @student
      @student = Index.find(params[:id]).student
    end
    @interupt = @student.index.interupts.build
  end

  def create
    @interupt = Interupt.new(params[:interupt])
    if @interupt.plan_changed.to_i == 1
      session[:interupt] = @interupt
      redirect_to(:action => 'change', :controller => 'study_plans',
                  :id => @interupt.index.student)
    else
      finish
    end
  end

  def finish
    @interupt ||= session[:interupt]
    @interupt.save
    if @user.has_role?('student')
      Notifications::deliver_interupt_alert(@interupt.index.study_plan,@interupt)
      redirect_to(:controller => 'interupts', :action => 'print_interupt',
                  :id => @interupt.id)
    else
      if @user.has_role?('faculty_secretary')
        @interupt.approve_like('dean', t(:message_0, :scope => [:txt, :controller, :interupts]))
        @interupt.index.interrupt!(@interupt.start_on)
      end
      redirect_to(:controller => 'students')
    end
  end

  # confirms interupt
  def confirm_approve
    @document = Interupt.find(params[:id])
    @document.approve_with(params[:statement])
    unless @document.index.study_plan.approved?
      @document.index.study_plan.approve_with(params[:statement])
    end
    if @user.has_role?('faculty_secretary')
      @document.index.interrupt!(@document.start_on)
    end
    
    if good_browser?
      render(:partial => 'shared/confirm_approve', 
             :locals => {:replace => 'interupt_approvement'})
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def confirm
    @index = Index.find(params[:id])
    @index.interrupt!(@index.interupt.start_on)
    if good_browser?
      render(:partial => 'students/redraw_student')
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def end
    @index = Index.find(params[:id])
    @index.end_interupt!(params[:date])
    if good_browser?
      render(:partial => 'students/redraw_student')
    else
      render(:partial => 'students/redraw_list')
    end
  end

  def print_interupt
     @interupt = Interupt.find(params[:id])
  end  
end
