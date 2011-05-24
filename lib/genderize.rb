module Genderize

  def genderize(common, male, female)
    if sex
      return male if 'M' == sex
      return female if 'F' == sex
    end
    return common
  end

  def print_sex
    if sex
      return I18n::t(:male, :scope => [:txt, :lib, :genderize]) if 'M' == sex
      return I18n::t(:female, :scope => [:txt, :lib, :genderize]) if 'F' == sex
    end
  end

end
