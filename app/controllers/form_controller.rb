class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
  end
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = "Formulář přihlášky na obor " + @candidate.coridor.name
    flash.now['notice'] = 'Vyplňte prosím všechny údaje, jejichž popiska je červená'
    all_ids
  end
  # preview what has been inserted
  def save
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.save
      preview
      render_action 'preview'
    else
      @title = "Formulář přihlášky - nedostatky"
      flash.now['error'] = "Ve Vámi zadaných informacích jsou následující chyby"
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
      @title = "Kontrola zadaného"
      flash.now['notice'] = "Prohlídněte si pozorně Vámi zadané informace. Poté postupujte podle návodu ve spodní části stránky." 
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
    @title = "Přihláška zaregistrována"
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
      c.state = "Česká republika"
      c.university = "Česká zemědělská univerzita v Praze"
      c.faculty = c.coridor.faculty.name
    end
  end
end
