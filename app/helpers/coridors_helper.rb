module CoridorsHelper

  def del_link(coridor_subject)
    link_to_remote(image_tag('minus.png'), 
                  :url => {:action => 'del_subject', :id => coridor_subject.id},
                  :complete => evaluate_remote_response,
                  :confirm => _('Are you sure to delete?')) 
  end

  def add_link(coridor, type)
    link = link_to_remote("%s&nbsp;%s" % [image_tag('plus.png'), 
                                          _('Add subject')],
                          :url => {:action => 'add_subject', :type => type},
                          :update => type.underscore.pluralize,
                          :position => :bottom)
       
  end

  def show_result(result)
    case result
    when 0
      return _('canceled')
    when 1
      return _('approved')
    when 2
      return _('approved with earfull')
    end
  end

end
