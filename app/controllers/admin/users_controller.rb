class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」さんを登録しました。"
    else
      render :new
    end
  end

  def update
    @user = User.find(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」さんを登録しました。"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」さんを削除しました。"
  end
  
    private
    
    def user_params
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
    end
end
