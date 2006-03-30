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
      return _('male') if 'M' == sex
      return _('female') if 'F' == sex
    end
    return nil
  end

end