class FormController < ApplicationController
  layout "standard"
  model :candidate
  # page where candidate chooses desired coridor
  # or logins for edit or check older adminition
  def index
    @faculties = Faculty.find_all
    @title = "Výbìr koridoru"
    flash.now['notice'] = "Kliknutím na fakultu se dostanete na seznam oborù/témat pro ni."
  end
  # form details  
  def details
    prepare_candidate
    @action = 'save'
    @title = "Formuláø pøihlá¹ky na obor " + @candidate.coridor.name
    flash.now['notice'] = 'Vyplñte prosím v¹echny údaje, jejich¾ popiska je èervená'
    all_ids
  end
  # preview what has been inserted
  def save
    @candidate = Candidate.new(@params['candidate'])
    if @candidate.save
      preview
      render_action 'preview'
    else
      @title = "Formuláø pøihlá¹ky - nedostatky"
      flash.now['error'] = "Ve vámi zadaných informacích jsou následující chyby"
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
      @title = "Formuláø pøihlá¹ky - nedostatky"
      flash.now['error'] = "Ve vámi zadaných informacích jsou následující chyby"
      @action = 'update'
      all_ids
      render_action "details"
    end
  end
  # preview information
  def preview
      @title = "Kontrola zadaného"
      flash.now['notice'] = "Prohlédnìte si pozornì Vámi zadané informace. Poté postupujte podle návodu ve spodní èásti stránky." 
  end
  # correct details
  def correct
    @candidate = Candidate.find(@params['id'])
    flash.now['notice'] = 'Vyplñte prosím v¹echny údaje, jejich¾ popiska je èervená'
    @action = 'update'
    all_ids
    @title = "Oprava pøihlá¹ky"
    render_action 'details'
  end
  # finish submition
  def finish
    @candidate = Candidate.find(@params['id'])
    @candidate.finish!
    @title = "Pøihlá¹ka zaregistrována"
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
      c.state = "Èeská republika"
      c.university = "Èeská zemìdìlská univerzita v Praze"
      c.faculty = c.coridor.faculty.name
    end
  end
end
