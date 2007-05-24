class FormController < ApplicationController
  include LoginSystem
  layout "employers"
  
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = _("Admittance process")
  end
  
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = _("Admittance form for corridor ") + @candidate.coridor.name
  end

  # preview what has been inserted
  def save
    @candidate = Candidate.new(params[:candidate])
    if @candidate.save
      preview
      render_action 'preview'
    else
      @title = _("Admittance form - errors")
      flash.now['error'] = _("Provided informations contains errors")
      @action = 'save'
      render_action 'details'
    end
  end

  # update candidate
  def update
    @candidate = Candidate.find(params[:candidate][:id])
    if @candidate.update_attributes(params[:candidate])
      preview
      render_action 'preview'
    else
      @title = _("Admittance form - errors")
      flash.now['error'] = _("Provided informations contains errors")
      @action = 'update'
      render_action 'details'
    end
  end

  # preview information
  def preview
    if @candidate
      @title = _("Check submited")
      flash.now['notice'] = _("Please check what you submited. Then folow guide on the bottom of the page") 
    else
      @candidate = Candidate.find(params[:id])
      @title = _("Print")
    end
  end

  # correct details
  def correct
    @candidate = Candidate.find(params[:id])
    flash.now['notice'] = _("Fields in red are required")
    @action = 'update'
    @title = _("Correct admit form")
    render_action 'details'
  end

  # finish submition
  def finish
    @candidate = Candidate.find(params[:id])
    @candidate.finish!
    @title = _("Admit form registered")
  end

  private
  # prepares candidate with some preloaded values
  def prepare_candidate
    @candidate = Candidate.new do |c| 
      c.coridor = Coridor.find(params[:id])
      c.state = _("Czech republic")
      c.address_state = _("Czech republic")
      c.university = _("Czech University of Life Sciences")
      c.faculty = c.coridor.faculty.name
      language1_id = 1133 if c.admitting_faculty == 3
    end
  end

end
