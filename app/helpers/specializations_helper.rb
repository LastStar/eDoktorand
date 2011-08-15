module SpecializationsHelper

  def del_link(specialization_subject)
    link_to_remote(image_tag('minus.png'),
                  :url => {:action => 'del_subject', :id => specialization_subject.id},
                  :confirm => t(:message_0, :scope => [:helper, :specializations]))
  end

  def add_link(specialization, type)
    link = link_to_remote("%s&nbsp;%s" % [image_tag('plus.png'),
                                          t(:message_1, :scope => [:helper, :specializations])],
                          :url => {:action => 'add_subject', :type => type},
                          :update => type.underscore.pluralize,
                          :position => :bottom)

  end

  def show_result(result)
    case result
    when 0
      return t(:finish, :scope => [:helper, :specializations])
    when 1
      return t(:continue, :scope => [:helper, :specializations])
    when 2
      return t(:continue_with_reproof, :scope => [:helper, :specializations])
    end
  end

end
