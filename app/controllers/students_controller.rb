class StudentsController < ApplicationController
  def index
    list
    render_action 'list'
  end

  def list
    @students = Student.find_all
  end

  def show
    @student = Student.find(@params[:id])
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(@params[:student])
    if @student.save
      flash['notice'] = 'Student was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @student = Student.find(@params[:id])
  end

  def update
    @student = Student.find(@params[:id])
    if @student.update_attributes(@params[:student])
      flash['notice'] = 'Student was successfully updated.'
      redirect_to :action => 'show', :id => @student
    else
      render_action 'edit'
    end
  end

  def destroy
    Student.find(@params[:id]).destroy
    redirect_to :action => 'list'
  end
end
