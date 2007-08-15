class InteruptsController < ApplicationController
  include LoginSystem
  helper :students
  helper :study_plans
  layout 'employers'
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
      redirect_to(:action => 'change', :controller => 'study_plans', :id => 
        @interupt.index.student)
    else
      finish
    end
  end

  def finish
    @interupt ||= session[:interupt]
    @interupt.save
    if @user.has_role?('student')
      Notifications::deliver_interupt_alert(@interupt.index.study_plan,@interupt)
      redirect_to(:controller => 'interupts', :action => 'print_interupt' ,:id => 
        @interupt.id)
    else
      if @user.has_role?('faculty_secretary')
        @interupt.approve_like('dean', _('faculty secretary approve'))
        @interupt.index.interrupt!(@interupt.start_on)
      end
      redirect_to(:controller => 'students')
    end
  end

  def confirm_approve
    interupt = Interupt.find(params[:id])
    interupt.approve_with(params[:statement])
    unless interupt.index.study_plan.approved?
      interupt.index.study_plan.approve_with(params[:statement])
    end
    if @user.has_role?('faculty_secretary')
      interupt.index.interrupt!(interupt.start_on)
    end
    
    render(:partial => 'shared/confirm_approve', 
           :locals => {:replace => 'interupt_approvement',
                       :document => interupt})
  end

  def confirm
    index = Index.find(params[:id])
    index.interrupt!(index.interupt.start_on)
    render(:inline => "<%= redraw_student(index) %>", :locals => {:index => index})
  end

  def end
    @index = Index.find(params[:id])
    @index.end_interupt!(params[:date])
    render(:inline => "<%= redraw_student(@index) %>")
  end

  def print_interupt
     @interupt = Interupt.find(params[:id])
  end  
end
