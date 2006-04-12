class ScholarshipsController < ApplicationController
  include LoginSystem
  layout "employers", :except => [:save, :change, :add, :edit]
  before_filter :set_title, :login_required, :prepare_student,
                :prepare_user

  def index
    list
    render :action => 'list'
  end

  def list
    @scholarships = Scholarship.find_all_by_index_id(@student.index.id)
  end

  # claim for accommodation scholarship
  def claim
    @student.scholarship_claimed_at = Time.now
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
    index.update_attributes(@params['index'])
    list
    render :action => 'list'
  end

  # scholarship list preparation
  def prepare
    @indices = Index.find_studying_for(@user, 
                                       :order => 'studies.id, people.lastname')
  end

  def change
    @scholarship = RegularScholarship.prepare_for_this_month(@params['id'])
  end

  # this method shows all extra scholarships for index
  def detail
    index = Index.find(@params['id'])
    scholarships = ExtraScholarship.find_all_unpayed_by_index(index.id)
    render_partial('detail', :index => index, :scholarships => scholarships)
  end
 
  # adding scholarships for faculty secretaries
  def add
   @index = Index.find(@params['id'])
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
    @indices = Index.find_studying_for(@user, 
                                       :order => 'studies.id, people.lastname')
    @indices.each do |i|
      ExtraScholarship.pay_for(i) if i.current_extra_scholarship
      RegularScholarship.pay_for(i)
    end
    redirect_to :action => 'prepare'
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

end
