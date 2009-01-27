module AccountHelper
  def locale_link
    if I18n.locale != 'cs'
      link_to image_tag('cz.png'), locale_url(:lang => 'cs')
    else
      link_to image_tag('gb.png'), locale_url(:lang => 'en')
    end
  end
end
