module CoridorsHelper

  def del_link(subject)
    link = link_to_remote(image_tag('minus.png'), :url => {:controller => 'coridors', :action => 'del_subject', :id => subject.id, :type => subject.type}, :update => 'main') 
  end

  def coridor_link(coridor)
    link = link_to_remote(image_tag('change.png'), :url => {:controller => 'coridors', :action => 'manage_edit', :id => coridor.id}, :update => 'main')+ coridor.name
  end

  def add_subject(coridor,subject)
    link = link_to_remote(image_tag('plus.png'), :url => {:controller => 'coridors', :action => 'add_subject', :id => coridor.id, :subject => subject}, :update => 'add_' + subject) + _('Add subject')   
  end

end
