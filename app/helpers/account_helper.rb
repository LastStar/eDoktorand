module AccountHelper
  # prints login form
  def login_form(&proc)
   form_tag({:action=> "login"},
            {:id => 'login-form',
            :onSubmit => "$('login-button').value = '%s'" %
              t(:message_0, :scope => [:view, :account, :login])},
            &proc)
  end
end
