class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = "Výbìr koridoru"
    flash['notice'] = "Kliknutím na fakultu se dostanete na seznam oborù/témat pro ni."
  end
  # form details  
  def details
    @candidate = Candidate.new
    @candidate.coridor = Coridor.find(@params['id'])
    @candidate.state = "Èeská republika"
    department_ids(@candidate.coridor.faculty.id)
    language_ids
    study_ids
    @title = "Formuláø pøihlá¹ky na obor " + @candidate.coridor.name
    flash['notice'] = 'vyplñte prosím v¹echny údaje, jejich¾ popiska je èervená'
  end
  # preview what has been inserted
  def preview
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.valid?
      @title = "Kontrola zadaného"
      flash['notice'] = "Prohlédnìte si pozornì Vámi zadané informace. Po té postupujte podle návodu na spodu stránky." 
    else
      @title = "Formuláø pøihlá¹ky - nedostatky"
      flash['error'] = "Ve vámi zadaných informacích jsou následující chyby"
      language_ids
      department_ids(@candidate.coridor.faculty.id)
      study_ids
      render_action "details"
    end
  end
end
