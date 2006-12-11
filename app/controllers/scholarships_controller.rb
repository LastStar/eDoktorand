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
  end

  # claim for accommodation scholarship
  def claim
    @student.claim_accommodation_scholarship!
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
    index = Index.find(params['id'])
    scholarships = ExtraScholarship.find_all_unpayed_by_index(index.id)
    render_partial('detail', :index => index, :scholarships => scholarships)
  end
 
  # adding scholarships for faculty secretaries
  def add
   @index = Index.find(params['id'])
   @scholarship = @index.extra_scholarships.build
  end
  
  def edit
    @scholarship = ExtraScholarship.find(@params['id'])
    render(:action => 'add')
  end

  def save
    if @params['scholarship']['id'] && !@params['scholarship']['id'].empty?
      update
    else
      create
    end
    @scholarship.save
    if @scholarship.is_a?(RegularScholarship)
      render(:partial => 'regular', :locals => {:index => @scholarship.index})
    else
      render(:partial => 'index_line', :locals => {:index => @scholarship.index})
    end
  end

  def recalculate
    index = Index.find(params['id'])
    index.regular_scholarship.update_attribute('amount', ScholarshipCalculator.for(index))
    render(:partial => 'regular', :locals => {:index => index})
  end

  def update
    @scholarship = Scholarship.find(@params['scholarship']['id'])
    @scholarship.attributes = @params['scholarship']
    @scholarship.amount = 0 if !@scholarship.amount 
  end

  def create
    @scholarship =
      eval("#{@params['scholarship']['type']}.new(@params['scholarship'])")
    @scholarship.amount = 0 if !@scholarship.amount
  end

  def destroy
    scholarship = ExtraScholarship.find(@params['id'])
    @index = scholarship.index
    @old_id = scholarship.id
    scholarship.destroy
  end

  def pay
    csv_headers('stipendia.csv')
    stipendias = Scholarship.pay_and_generate_for(@user)
    date = (Time.now - 1.month).strftime('%Y%m')
    file = "#{RAILS_ROOT}/public/csv/#{date}.csv"
    File.open(file, 'w') {|file| file.write(stipendias)}
    # TODO send mail to machyk
    render(:text => stipendias)
  end
  
  def approve
    @indices = Scholarship.approve_for(@user)
    render(:action => 'list')
  end
  
  # saves scholarship to dbase
  def save_scholarship
    @index = Index.find(@params['index']['id'])
    scholarship = @session['scholarship']
    scholarship.attributes = @params['scholarship']
    scholarship.index_id = @index.id
    scholarship.save
    @scholarships =
    Scholarship.find_all_by_index_id(@index.id)
    render_partial('render_detail', :scholarships =>
      @scholarships, :index => @index)
  end

  # sets title of the controller
  def set_title
    @title = _('Scholarships')
  end

  def next_action_for(user)
    if user.has_one_of_roles?(['faculty_secretary', 'department_secretary'])
      if Scholarship.prepare_time? && !ScholarshipApprovement.approved_for?(user.person.faculty)
        :prepare
      else
        :list
      end
    end
  end
  
end
