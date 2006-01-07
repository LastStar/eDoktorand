class InteruptsController < ApplicationController
  include LoginSystem
  helper :students
  layout 'employers'
  before_filter :login_required, :prepare_student, :prepare_user
  def index
    unless @student
      @student = Index.find(@params['id']).student
    end
    @interupt = @student.index.build_interupt
  end
  def create
    @interupt = Interupt.new(@params['interupt'])
    if @interupt.plan_changed.to_i == 1
      @session['interupt'] = @interupt
      redirect_to(:action => 'change', :controller => 'study_plans', :id => 
        @interupt.index.student)
    else
      finish
    end
  end
  def finish
    @interupt ||= @session['interupt']
    @interupt.save
    redirect_to(:controller => 'study_plans')
  end
  def confirm_approve
    interupt = Interupt.find(@params['id'])
    interupt.approve_with(@params['statement'])
    unless interupt.index.study_plan.approved?
      interupt.index.study_plan.approve_with(@params['statement'])
    end
    render(:inline => "Element.hide('approve_form#{interupt.id}'); \
      Element.remove('index_line_#{interupt.index.id}')")
  end
  def confirm
    index = Index.find(@params['id'])
    index.update_attribute('interupted_on', index.interupt.start_on)
    render(:inline => "<%= redraw_student(index) %>", :locals => {:index => index})
  end
end
