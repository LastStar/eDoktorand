module SpecializationsHelper

  def del_link(specialization_subject)
    link_to_remote(image_tag('minus.png'),
                  :url => {:action => 'del_subject', :id => specialization_subject.id},
                  :confirm => I18n::t(:message_0, :scope => [:helper, :specializations]))
  end

  def add_link(specialization, type)
    link = link_to_remote("%s&nbsp;%s" % [image_tag('plus.png'),
                                          I18n::t(:message_1, :scope => [:helper, :specializations])],
                          :url => {:action => 'add_subject', :type => type},
                          :update => type.underscore.pluralize,
                          :position => :bottom)

  end

  def show_result(result)
    case result
    when 0
      return I18n::t(:finish, :scope => [:helper, :specializations])
    when 1
      return I18n::t(:continue, :scope => [:helper, :specializations])
    when 2
      return I18n::t(:continue_with_reproof, :scope => [:helper, :specializations])
    end
  end

  # translates approver
  def translate_approver(approver)
    if approver
      I18n::t(approver.to_s.downcase, :scope => [:helper, :application])
    else
      I18n::t(:nobody, :scope => [:helper, :application])
    end
  end
end
