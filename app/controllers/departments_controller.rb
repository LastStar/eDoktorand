class DepartmentsController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @departments = Department.find_all
  end

  def show
    @department = Department.find(@params['id'])
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(@params['department'])
    if @department.save
      flash['notice'] = 'Department was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @department = Department.find(@params['id'])
  end

  def update
    @department = Department.find(@params['department']['id'])
    if @department.update_attributes(@params['department'])
      flash['notice'] = 'Department was successfully updated.'
      redirect_to :action => 'show', :id => @department.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Department.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
