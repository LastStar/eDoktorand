class Notifications < ActionMailer::Base
  def invite_candidate(candidate, sent_at = Time.now)
    @subject = 'Pozvánka na příjimací zkoušky na doktorské studium'
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @recipients = candidate.email
    @from       = 'pepe@gravastar.cz'
    @sent_on    = sent_at
  end
  def admit_candidate(candidate, sent_at = Time.now)
    @subject = 'Vyrozumění o příjimacím řízení na doktorské studium'
    @body['display_name'] = candidate.display_name
    @body['address'] = candidate.address
    @body['coridor'] = candidate.coridor.name
    @body['admit'] = candidate.admittance.dean_conclusion_admit
    @body['exam_term'] = candidate.coridor.exam_term
    @body['sent_on'] = sent_at
    @recipients = candidate.email
    @from = 'pepe@gravastar.cz'
    @sent_on = sent_at
  end

	private
	# returns admit word
  def admit_word(id)	
  	['nepříjmout', 'příjmout'][id]
  end
end
