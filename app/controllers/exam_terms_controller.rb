class ExamTermsController < ApplicationController
  include LoginSystem
  layout 'employers'
  before_filter :login_required, :prepare_user

  def index
    list
    render_action 'list'
  end

  def list
		@title = 'Výpis komisí příjimacích zkoušek'
    @exam_term_pages, @exam_terms = paginate :exam_term, :per_page => 10
  end

  def show
    @exam_term = ExamTerm.find(@params[:id])
  end

  def new
  	@title = 'Vytváření komise příjimacích zkoušek'
    @exam_term = ExamTerm.new
		@exam_term.coridor_id = @params['id'] if @params['id']
  end

  def create
    @exam_term = ExamTerm.new(@params[:exam_term])
    if @exam_term.save
      flash['notice'] = 'Komise byla úspěšně vytvořena.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @exam_term = ExamTerm.find(@params[:id])
  end

  def update
    @exam_term = ExamTerm.find(@params[:id])
    if @exam_term.update_attributes(@params[:exam_term])
      flash['notice'] = 'Komise byla úspěšně opravena'
      redirect_to :action => 'list'
    else
      render_action 'edit'
    end
  end

  def destroy
    ExamTerm.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
