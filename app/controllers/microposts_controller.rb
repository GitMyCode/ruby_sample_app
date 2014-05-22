class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def index
  end

  def create
    #contruit le nouveau micropost a partir des paramettre
    @micropost = current_user.microposts.build(micropost_param)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end

  end

  def destroy
  end

  private
      def micropost_param
        params.require(:micropost).permit(:content)
      end


end