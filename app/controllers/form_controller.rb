class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = "V�b�r koridoru"
    flash.now['notice'] = "Kliknut�m na fakultu se dostanete na seznam obor�/t�mat pro ni."
  end
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = "Formul�� p�ihl�ky na obor " + @candidate.coridor.name
    flash.now['notice'] = 'Vypl�te pros�m v�echny �daje, jejich� popiska je �erven�'
    all_ids
  end
  # preview what has been inserted
  def save
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.save
      preview
      render_action 'preview'
    else
      @title = "Formul�� p�ihl�ky - nedostatky"
      flash.now['error'] = "Ve v�mi zadan�ch informac�ch jsou n�sleduj�c� chyby"
      @action = 'save'
      all_ids
      render_action "details"
    end
  end
  # update candidate
  def update
    @candidate = Candidate.find(@params['candidate']['id'])
    @candidate.attributes = @params['candidate']
    if @candidate.save
      preview
      render_action 'preview'
    else
      @title = "Formul�� p�ihl�ky - nedostatky"
      flash.now['error'] = "Ve v�mi zadan�ch informac�ch jsou n�sleduj�c� chyby"
      @action = 'update'
      all_ids
      render_action "details"
    end
  end
  # preview information
  def preview
      @title = "Kontrola zadan�ho"
      flash.now['notice'] = "Prohl�dn�te si pozorn� V�mi zadan� informace. Pot� postupujte podle n�vodu ve spodn� ��sti str�nky." 
  end
  # correct details
  def correct
    @candidate = Candidate.find(@params['id'])
    flash.now['notice'] = 'Vypl�te pros�m v�echny �daje, jejich� popiska je �erven�'
    @action = 'update'
    all_ids
    @title = "Oprava p�ihl�ky"
    render_action 'details'
  end
  # finish submition
  def finish
    @candidate = Candidate.find(@params['id'])
    @candidate.finish!
    @title = "P�ihl�ka zaregistrov�na"
  end
  private
  # get all ids
  def all_ids
    department_ids(@candidate.coridor.faculty.id)
    language_ids
    study_ids
  end
  # prepares candidate with some preloaded values
  def prepare_candidate
    @candidate = Candidate.new do |c| 
      c.coridor = Coridor.find(@params['id'])
      c.state = "�esk� republika"
      c.university = "�esk� zem�d�lsk� univerzita v Praze"
      c.faculty = c.coridor.faculty.name
    end
  end
end
