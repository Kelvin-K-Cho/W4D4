class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Invalid username/password"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to cats_url
  end
end
