require 'terms_calculator'
class ScholarshipsController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:save, :change, :add, :edit, :sum,
    :search_to_add]
  before_filter :set_title, :login_required, :prepare_student,
                :prepare_user
  helper_method :scholarship_file

  def index
    redirect_to :action => next_action_for(@user)
  end

  def list
    @paying_date = ScholarshipMonth.current.starts_on
    @indices = Index.find_with_scholarship(@user)
    if @user.has_role?('supervisor')
      @approvals = ScholarshipApproval.current
    end
  end

  # claim for accommodation scholarship
  def claim
    @student.index.claim_accommodation_scholarship!
    @school_year = TermsCalculator.current_school_year
  end

  # scholarship list preparation
  def prepare
    @paying_date = ScholarshipMonth.current.starts_on
    @indices = Index.find_for_scholarship(@user, @paying_date)
    @over = Index.find_with_scholarship(@user).reject do |i|
      @indices.include?(i) ||
        (i.extra_scholarships.empty? &&
         i.regular_scholarship &&
         i.regular_scholarship.amount ==  0)
    end
  end

  def change
    index = Index.find(params['id'])
    @scholarship = RegularScholarship.prepare_for_this_month(index)
  end

  # this method shows all extra scholarships for index
  def detail
    @index = Index.find(params['id'])
    @scholarships = ExtraScholarship.find_all_unpaid_by_index(@index.id)
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

  def save
    @paying_date = ScholarshipMonth.current.starts_on
    if params[:scholarship][:id] && !params[:scholarship][:id].empty?
      update
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
    @paying_date = ScholarshipMonth.current.starts_on
    @indices = Index.find_for_scholarship(@user, ScholarshipMonth.current.starts_on)
    RegularScholarship.recalculate_amount(@indices)
    render(:action => :prepare)
  end

  def student_list
    @index = @student.index
    @scholarships = @index.paid_scholarships
  end

  def secretary_list
    @index = Index.find(params[:id])
    @scholarships = @index.paid_scholarships
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
    @scholarship.scholarship_month = ScholarshipMonth.current
    @scholarship.amount = 0 if !@scholarship.amount
  end

  def destroy
    scholarship = ExtraScholarship.find(params[:id])
    @index = scholarship.index
    @old_id = scholarship.id
    scholarship.destroy
  end

  def destroy_over
    scholarship = Scholarship.find(params[:id])
    scholarship.destroy
    render :text => "Destroyed", :status => 200
  end

  def pay
    csv_headers('stipendia.csv')
    stipendias = Scholarship.pay_and_generate
    file = "#{RAILS_ROOT}/public#{scholarship_file}"
    File.open(file, 'w') {|file| file.write(stipendias)}

    # TODO send mail to machyk
    redirect_to :action => :list
  end

  def unpay
    ScholarshipMonth.current.unpay!
    file = "#{RAILS_ROOT}/public#{scholarship_file}"
    FileUtils.rm(file)

    redirect_to :action => :control_table
  end

  def close
    ScholarshipMonth.current.close!

    redirect_to :action => :list
  end

  def approve
    ScholarshipApproval.approve_for(@user)

    redirect_to :action => :list
  end

  # renders control table of scholarships
  def control_table
    @paying_date = ScholarshipMonth.current.starts_on
    @indices = Index.find_with_scholarship(@user)
    @show_table_message = 1
    @bad_indices = @indices.select(&:bad_index?)
    render(:action => 'list')
  end

  # sets title of the controller
  def set_title
    @title = t(:message_0, :scope => [:controller, :scholarships])
  end

  def next_action_for(user)
    if user.has_one_of_roles?(['faculty_secretary', 'department_secretary', 'leader','vicerector'])
      if !ScholarshipApproval.approved_for?(user.person.faculty)
        :prepare
      else
        :list
      end
    end
  end

  def unapprove
    @approval = ScholarshipApproval.find(params[:id])
    @approval.destroy
    redirect_to :action => :list
  end

  def scholarship_file
    "/csv/#{ScholarshipMonth.current.title}.csv"
  end

  def search_to_add
    @indices = Index.find_for(@user, :search => params[:lastname], :order => 'people.lastname')
  end
end
