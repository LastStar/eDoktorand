class TutorsController < ApplicationController

  include LoginSystem
  layout "employers", :except => [:edit]
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
  end

  def update
    @tutorship = Tutorship.find(params[:tutorship][:id])
    @tutorship.update_attributes(params[:tutorship])
  end  
end
