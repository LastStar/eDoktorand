module AccountHelper
  def locale_link
    if GetText.locale.language != 'cs'
      link_to image_tag('cz'), locale_url(:lang => 'cs')
    else
      link_to image_tag('gb'), locale_url(:lang => 'en')
    end
  end
end
