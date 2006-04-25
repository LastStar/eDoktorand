class FinalExamTermsController < ApplicationController
  include LoginSystem
  before_filter :login_required, :prepare_user

  def new
    @title = 'Vytváření komise SZZ'
    index = Index.find(@params['id']) if @params['id']
    if index.final_exam_term
      @exam_term = index.final_exam_term
    else 
      @exam_term = FinalExamTerm.new
      @exam_term.index = index
    end 
    render_action :new
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
      render_action :remote
    else
      render_action :new
    end
  end

  def destroy
    FinalExamTerm.find(@params[:id]).destroy
    redirect_to :action => 'list' #TODO render proper action
  end

end
