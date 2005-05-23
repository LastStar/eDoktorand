class PeopleController < ApplicationController
	model :title
  def index
    list
    render_action 'list'
  end

  def list
    @person_pages, @people = paginate :person, :per_page => 10
  end

  def show
    @person = Person.find(@params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(@params[:person])
    if @person.save
      flash['notice'] = 'Person was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @person = Person.find(@params[:id])
  end

  def update
    @person = Person.find(@params[:id])
    if @person.update_attributes(@params[:person])
      flash['notice'] = 'Person was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      render_action 'edit'
    end
  end

  def destroy
    Person.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
