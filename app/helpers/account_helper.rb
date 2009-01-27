module AccountHelper
  def locale_link
    if locale.language != 'cs'
      link_to image_tag('cz.png'), locale_url(:lang => 'cs_CZ')
    else
      link_to image_tag('gb.png'), locale_url(:lang => 'en')
    end
  end
end
