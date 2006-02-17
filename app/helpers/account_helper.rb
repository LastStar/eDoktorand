module AccountHelper
  def locale_link
    if @session['locale'] && @session['locale'] != 'cs_CZ'
      link_to _('czech'), locale_url(:locale => 'cs_CZ')
    else
      link_to _('english'), locale_url(:locale => 'en_EN')
    end
  end
end
