class ScholarshipsController < ApplicationController
  include LoginSystem
  layout "employers"
  before_filter :set_title
  before_filter :login_required
  before_filter :prepare_student
  before_filter :prepare_user

  def index
    list
    render :action => 'list'
  end

  def list
    @scholarships = []
    @index = @user.person.index
    @scholarships =
    Scholarship.find_all_by_index_id(@index.id)
  end

# claim for accommodation scholarship
  def claim
    @student = @user.person
    @student.scholarship_claim_date = Time.now
    @student.save
  end
  
  # form for changing account number
  def account_change
    @index = Index.find(@params['id'])
    render_partial('account_change')
  end

  # this method saves the account to dbase
  def save_account
    index = Index.find(@params['index']['id'])
    index.account_number_prefix = @params['index']['account_number_prefix']
    index.account_number = @params['index']['account_number']
    index.account_bank_number = @params['index']['account_bank_number']
    index.save
    list
    render :action => 'list'
  end

  # scholarship list preparation
  def scholarship
    conditions = [" AND (interupted_on IS NULL OR interupted_on LIKE '0000-00-00 00:00:00') AND (finished_on IS NULL OR finished_on LIKE '0000-00-00 00:00:00')"]
    @indices = Index.find_for_user(@user, :conditions => conditions)
  end

  # this method shows all extra scholarships for index
  def detail
    @index = Index.find(@params['id'])
    @scholarships =
    Scholarship.find_all_by_index_id(@index.id)
    render_partial('detail', :index => @index, :scholarships => @scholarships)
  end
 
  # adding scholarships for faculty secretaries
  def add_scholarship
   scholarship = Scholarship.new
   index = Index.find(@params['id'])
   @session['scholarship'] = scholarship
   render(:partial => 'add_scholarship', :locals => {:scholarship => scholarship, :index => index})
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
    @title = _('Exams')
  end
end
