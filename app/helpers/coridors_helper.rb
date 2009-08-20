module CoridorsHelper

  def del_link(coridor_subject)
    link_to_remote(image_tag('minus.png'), 
                  :url => {:action => 'del_subject', :id => coridor_subject.id},
                  :confirm => t(:message_0, :scope => [:txt, :helper, :coridors])) 
  end

  def add_link(coridor, type)
    link = link_to_remote("%s&nbsp;%s" % [image_tag('plus.png'), 
                                          t(:message_1, :scope => [:txt, :helper, :coridors])],
                          :url => {:action => 'add_subject', :type => type},
                          :update => type.underscore.pluralize,
                          :position => :bottom)
       
  end

  def show_result(result)
    case result
    when 0
      return t(:message_2, :scope => [:txt, :helper, :coridors])
    when 1
      return t(:message_3, :scope => [:txt, :helper, :coridors])
    when 2
      return t(:message_4, :scope => [:txt, :helper, :coridors])
    end
  end

end
