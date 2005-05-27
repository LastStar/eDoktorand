class StudyPlansController < ApplicationController
  model :student
  model :user
  include LoginSystem
  layout 'students'
	before_filter :login_required, :student_required
	# page with basic informations for student 
	def index
		@title = "Studijní plán"
	end
	
	private	
	# checks if user is student. 
	# if true creates @student variable with current student
	def student_required
		@student = @session['user'].person
		unless @student.kind_of?(Student)	
			flash['error'] = 'Tato stránka je jen pro studenty'
			redirect_to :controller => 'account', :action => 'error' 
		end
	end
end
