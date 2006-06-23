module AccountHelper
  def locale_link
    if @session['locale'] && @session['locale'] != 'cs_CZ'
      link_to image_tag('cz'), locale_url(:locale => 'cs_CZ')
    else
      link_to image_tag('gb'), locale_url(:locale => 'en_EN')
    end
  end
end
