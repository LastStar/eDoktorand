class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = "V�b�r koridoru"
    flash['notice'] = "Kliknut�m na fakultu se dostanete na seznam obor�/t�mat pro ni."
  end
  # form details  
  def details
    @candidate = Candidate.new
    @candidate.coridor = Coridor.find(@params['id'])
    @candidate.state = "�esk� republika"
    department_ids(@candidate.coridor.faculty.id)
    language_ids
    study_ids
    @title = "Formul�� p�ihl�ky na obor " + @candidate.coridor.name
    flash['notice'] = 'vypl�te pros�m v�echny �daje, jejich� popiska je �erven�'
  end
  # preview what has been inserted
  def preview
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.valid?
      @title = "Kontrola zadan�ho"
      flash['notice'] = "Prohl�dn�te si pozorn� V�mi zadan� informace. Po t� postupujte podle n�vodu na spodu str�nky." 
    else
      @title = "Formul�� p�ihl�ky - nedostatky"
      flash['error'] = "Ve v�mi zadan�ch informac�ch jsou n�sleduj�c� chyby"
      language_ids
      department_ids(@candidate.coridor.faculty.id)
      study_ids
      render_action "details"
    end
  end
end
