class FinalExamTermsController < ApplicationController
  include LoginSystem

  before_filter :login_required, :prepare_user

  def new
    @title = _('Creating final exam term')
    index = Index.find(@params['id']) 
    if index.final_exam_term
      @exam_term = index.final_exam_term
    else
      @exam_term = FinalExamTerm.new
      @exam_term.index = index
    end
  end

  def create
    @exam_term = FinalExamTerm.new(@params[:exam_term])
    tmp = FinalExamTerm.find_by_index_id(@exam_term.index.id)
    if tmp
      @exam_term = tmp
      @exam_term.update_attributes(@params[:exam_term])
    end 
    if @exam_term.save
      flash['notice'] = 'Komise byla úspěšně vytvořena.'
      render_action :show
    else
      render_action :new
    end
  end

  def show
    @exam_term = FinalExamTerm.find(@params[:id])
  end

  def edit
    @exam_term = FinalExamTerm.find(@params[:id])
  end

  def destroy
    FinalExamTerm.find(@params[:id]).destroy
    redirect_to :action => 'list' #TODO render proper action
  end

  def send_invitation
    # add mail sending and setting that mail was sent
    @index = Index.find(params[:id])
    @index.send_final_exam_invitation!
    render(:text => _('e-mail sent'))
  end

end
