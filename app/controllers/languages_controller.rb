class LanguagesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @languages = Language.find_all
  end

  def show
    @language = Language.find(@params['id'])
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.new(@params['language'])
    if @language.save
      flash['notice'] = 'Language was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @language = Language.find(@params['id'])
  end

  def update
    @language = Language.find(@params['language']['id'])
    if @language.update_attributes(@params['language'])
      flash['notice'] = 'Language was successfully updated.'
      redirect_to :action => 'show', :id => @language.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Language.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
