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
end
