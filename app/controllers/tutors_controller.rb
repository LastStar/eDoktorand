class TutorsController < ApplicationController

  include LoginSystem
  layout "employers", :except => [:edit]
  #before_filter :set_title
  before_filter :login_required
  before_filter :prepare_user

  def index
    list
    render_action 'list'
  end
  
  def list
    @tutors = Tutor.find(:all, :order => "lastname")
  end
  
  def edit
    @tutor = Tutor.find(@params[:id])
    @coridors_name = Coridor.find_all_by_faculty_id(@tutor.faculty.id).collect {|p| [ p.name, p.id ] }   
  end

  def save_coridor
    @tutor = Tutor.find(@params[:tutor][:id])
    coridor_id = @params[:coridor][:coridor_id]
    if @tutor.tutorship != nil
      @tutor.tutorship.coridor_id = coridor_id
      @tutor.tutorship.save
    else
      tutorship = Tutorship.new
      tutorship.coridor_id = coridor_id
      tutorship.tutor_id = @tutor.id
      tutorship.department_id = @tutor.department.id
      #tutorship.created_on = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      tutorship.save     
    end
  end  
end
