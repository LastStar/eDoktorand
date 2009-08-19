class TutorsController < ApplicationController

  include LoginSystem
  layout "employers", :except => [:edit]
  before_filter :login_required
  before_filter :prepare_user
  

  def index
    list
    render(:action => :list)
  end
  
  def list
    @tutors = Tutor.find_for(@user)
  end
  
  def edit
    @tutorship = Tutorship.find(params[:id])
    @coridors = Coridor.accredited_for(@user)
    render :partial => 'edit'
  end

  def update
    @tutorship = Tutorship.find(params[:tutorship][:id])
    @tutorship.update_attributes(params[:tutorship])
    @tutor = @tutorship.tutor
  end  
end
