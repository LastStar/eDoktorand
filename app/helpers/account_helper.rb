module AccountHelper
  def locale_link
    if I18n.locale != 'cs'
      link_to image_tag('cz.png', :style => 'margin: 5px 0px 7px 2px'), locale_url(:lang => 'cs')
    else
      link_to image_tag('gb.png'), locale_url(:lang => 'en')
    end
  end

  # prints login form
  def login_form(&proc)
   form_tag({:action=> "login"},
            {:id => 'login-form',
            :onSubmit => "$('login-button').value = '%s'" % 
              t(:message_0, :scope => [:txt, :view, :account, :login, :rhtml])},
            &proc) 
  end
end
