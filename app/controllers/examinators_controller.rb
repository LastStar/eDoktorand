class ExaminatorsController < ApplicationController
  
   include LoginSystem
  layout "employers", :except => [:edit]
  before_filter :login_required
  before_filter :prepare_user
  

  def index
    list
    render(:action => :list)
  end
  
  def list
    @examinators = Examinator.find_for(@user)
  end
  
  def edit
    @department_employment = DepartmentEmployment.find(params[:id])
    @departments = Department.find_all_by_faculty_id(@user.person.faculty.id)
    @examinator = Examinator.find(@department_employment.person_id)
    render :partial => 'edit'
  end

  def update
    @examinator = Examinator.find(params[:examinator][:id].to_i)
    @examinator.department_employment.update_attribute(:unit_id, params[:department_employment][:unit_id].to_i )
   
  end  
  
  
  
end
