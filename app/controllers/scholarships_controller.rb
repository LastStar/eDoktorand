require 'terms_calculator'
class ScholarshipsController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:save, :change, :add, :edit, :sum]
  before_filter :set_title, :login_required, :prepare_student,
                :prepare_user

  def index
    redirect_to :action => next_action_for(@user)
  end

  def list
    @indices = Index.find_for_scholarship(@user, 
                                         :order => 'studies.id, people.lastname',
                                         :include => [:student, :study, :disert_theme])
    if @user.has_role?('supervisor')
      @approvals = ScholarshipApprovement.last_weeks
    end
  end

  # claim for accommodation scholarship
  def claim
    @student.index.claim_accommodation_scholarship!
    @school_year = TermsCalculator.current_school_year
  end

  # scholarship list preparation
  def prepare
    @indices = Index.find_for_scholarship(@user, 
                                         :order => 'studies.id, people.lastname',
                                         :include => [:student, :study, 
                                                      :disert_theme])
  end

  def change
    index = Index.find(params['id'])
    @scholarship = RegularScholarship.prepare_for_this_month(index)
  end

  # this method shows all extra scholarships for index
  def detail
    @index = Index.find(params['id'])
    @scholarships = ExtraScholarship.find_all_unpayed_by_index(@index.id)
  end
 
  # adding scholarships for faculty secretaries
  def add
   @index = Index.find(params['id'])
   @scholarship = @index.extra_scholarships.build
  end
  
  def edit
    @scholarship = ExtraScholarship.find(params[:id])
    render(:action => 'add')
  end

  # FIXME what the fuck is edit for?
  def save
    @edit = 0
    if params[:scholarship][:id] && !params[:scholarship][:id].empty?
      update
      @edit = 1
    else
      create
    end
    if @scholarship.is_a?(RegularScholarship)
      @scholarship.save
      render(:partial => 'regular', :locals => {:index => @scholarship.index})
    else
      unless @scholarship.save
        render(:action => 'unsaved', :locals => {:scholarship => @scholarship})
      end
    end
  end

  def recalculate
    @indices = Index.find_for_scholarship(@user, 
                                         :order => 'studies.id, people.lastname',
                                         :include => [:student, :study, 
                                                      :disert_theme])
    RegularScholarship.recalculate_amount(@indices)
    render(:action => :prepare)
  end
  
  def student_list
    @index = @student.index
  end
    
  def update
    @scholarship = Scholarship.find(params[:scholarship][:id])
    unless @scholarship.attributes = params[:scholarship]
      render(:action => 'add')
    end  
    @scholarship.amount = 0 if !@scholarship.amount 
  end

  def create
    unless @scholarship =
      eval("#{params[:scholarship][:type]}.new(params[:scholarship])")
      render(:action => 'add')
    end
    @scholarship.amount = 0 if !@scholarship.amount
  end

  def destroy
    scholarship = ExtraScholarship.find(params[:id])
    @index = scholarship.index
    @old_id = scholarship.id
    scholarship.destroy
  end

  def pay
    csv_headers('stipendia.csv')
    stipendias = Scholarship.pay_and_generate_for(@user)
    date = Time.now.last_month.strftime('%Y%m')
    file = "#{RAILS_ROOT}/public/csv/#{date}.csv"
    File.open(file, 'w') {|file| file.write(stipendias)}
    # TODO send mail to machyk
    render(:text => stipendias)
  end
  
  def approve
    @indices = Scholarship.approve_for(@user)
    render(:action => 'list')
  end
  
  # renders control table of scholarships
  def control_table
    @indices = Index.find_for_scholarship(@user, 
                                         :order => 'studies.id, people.lastname',
                                         :include => [:student, :study, :disert_theme])
    @show_table_message = 1
    @bad_indices = []
    #TO DO rewrite to identihas_any_scholarshipfy bad index by itself - method in index model
    for index in @indices
      if index.bad_index? 
          @bad_indices << index
      end
    end
    render(:action => 'list')
  end
  
  # sets title of the controller
  def set_title
    @title = t(:message_0, :scope => [:txt, :controller, :scholarships])
  end

  def next_action_for(user)
    if user.has_one_of_roles?(['faculty_secretary', 'department_secretary', 'leader','vicerector'])
      if !ScholarshipApprovement.approved_for?(user.person.faculty)
        :prepare
      else
        :list
      end
    end
  end

  def unapprove
    @approval = ScholarshipApprovement.find(params[:id])
    @approval.destroy
    redirect_to :action => :list
  end
  
end
