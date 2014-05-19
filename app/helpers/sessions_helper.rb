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

  def current_user?(user)
    user == current_user
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

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)# si on efface pas les prochaine tentative de connection
                              # vont rediriger a cette adresse
  end

  #store l<url dans la variable session accessible par le hask :return_to
  # mais seulement si la request est un get pour empecher qu'il soit declancher par
  # un user qui submit une form sans etre logger
  def store_location
    session[:return_to] = request.url if request.get?
  end

end
