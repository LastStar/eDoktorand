module Genderize

  def genderize(common ,male , female)
    if sex
      return male if 'M' == sex
      return female if 'F' == sex
    end
    return common
  end

  def print_sex
    if sex
      return I18n::t(:message_0, :scope => [:txt, :lib, :genderize]) if 'M' == sex
      return I18n::t(:message_1, :scope => [:txt, :lib, :genderize]) if 'F' == sex
    end
    return nil
  end

end