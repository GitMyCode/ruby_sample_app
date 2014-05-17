module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token #utiliser la fonction dans User pour un token
    cookies.permanent[:remember_token] = remember_token # mettre ce token dans les cookies
    user.update_attribute(:remember_token, User.digest(remember_token)) # enregistrer ce token dans le user avec sa
                                                                        # fonction hash
    self.current_user = user # apparamment pas vraiment necessaire a cause qu'il y a une redirection ensuite dans while
                             # create du controller

  end


  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end


  def sign_out
    #creer un nouveau token pour ne pas que ce soit toujour le meme
    # par securiter
    current_user.update_attribute(:remember_token,
                        User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil # optional

  end

end
