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
   if @user.has_role?('vicerector')
      @examinators = []
      faculties = Faculty.find(:all)
      for faculty in faculties do
         @examinators.concat(Examinator.find_for_faculty(faculty))
      end
   else
      @examinators = Examinator.find_for_faculty(@user.person.faculty)
   end
  end
  
  def edit
   @department_employment = DepartmentEmployment.find(params[:id])
   @departments = []
   if @user.has_role?('vicerector')
      faculties = Faculty.find(:all)
      for faculty in faculties do
         @departments.concat(Department.find_all_by_faculty_id(faculty.id))
      end      
   else
      @departments = Department.find_all_by_faculty_id(@user.person.faculty.id)
   end
   @examinator = Examinator.find(@department_employment.person_id)
   render :partial => 'edit'
  end

  def update
    @examinator = Examinator.find(params[:examinator][:id].to_i)
    @examinator.department_employment.update_attribute(:unit_id, params[:department_employment][:unit_id].to_i )
   
  end  
  
  
  
end
