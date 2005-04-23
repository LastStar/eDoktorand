class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = "Přijímací řízení k doktorskému studiu"
  end
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = "Formulář přihlášky na obor " + @candidate.coridor.name
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
      render_action 'details'
    end
  end
  # update candidate
  def update
    @candidate = Candidate.find(@params['candidate']['id'])
    if @candidate.update_attributes(@params['candidate'])
      preview
      render_action 'preview'
    else
      @title = "Formulář přihlášky - nedostatky"
      flash.now['error'] = "Ve vámi zadaných informacích jsou následující chyby"
            @action = 'update'
      render_action 'details'
    end
  end
  # preview information
  def preview
      if @candidate
        @title = "Kontrola zadaného"
        flash.now['notice'] = "Prohlídněte si pozorně Vámi zadané informace. Poté postupujte podle návodu ve spodní části stránky." 
      else
        @candidate = Candidate.find(@params['id'])
        @title = "Tisk"
      end
  end
  # correct details
  def correct
    @candidate = Candidate.find(@params['id'])
    flash.now['notice'] = 'Vyplňte prosím všechny údaje, jejichž popiska je červená'
    @action = 'update'
    @title = "Oprava přihlášky"
    render_action 'details'
  end
  # finish submition
  def finish
    @candidate = Candidate.find(@params['id'])
    @candidate.finish!
    @title = "Přihláška zaregistrována"
  end
  private
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
