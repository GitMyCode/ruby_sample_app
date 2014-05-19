class UsersController < ApplicationController

  #va permettre de rediriger un utilisateur qui ne devrait pas acceder l'action edit ou update
  before_action :signed_in_user, only: [:index , :edit, :update]
  before_action :correct_user , only: [:edit, :update]
  before_action :admin_user , only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success]= "Welcome to the Sample App"
      sign_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]  = "Modification reussite!"
      redirect_to @user
    else
      puts @user.errors.full_messages
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

def destroy
  @user = User.find(params[:id])
  @user.destroy!
  flash[:success] = "User deleted!"
  redirect_to users_path
end



  private ##############################################################

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # si l'utilisateur n'est pas signer alors le rediriger
  # le notice unless envoi un flash[:notice] = " "
  def signed_in_user
    store_location #pour ensuite rediriger l'utilisateur vers la destination qu'il voulait avant
                   # d'etre rediriger vers la pagne d'authentification
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end


end
