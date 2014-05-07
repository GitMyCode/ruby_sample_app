class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end
end
