class TitlesController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @titles = Title.find_all
  end

  def show
    @title = Title.find(@params[:id])
  end

  def new
    @title = Title.new
  end

  def create
    @title = Title.new(@params[:title])
    if @title.save
      flash['notice'] = 'Title was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @title = Title.find(@params[:id])
  end

  def update
    @title = Title.find(@params[:id])
    if @title.update_attributes(@params[:title])
      flash['notice'] = 'Title was successfully updated.'
      redirect_to :action => 'show', :id => @title
    else
      render_action 'edit'
    end
  end

  def destroy
    Title.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
