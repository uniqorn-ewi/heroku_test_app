class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # テーブルの中に、avatarのカラム（画像アップロード用のカラム）以外のものがある場合、
    # new(xxxx_params)にする。
    @user = User.new(user_params)
    # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
    unless params[:cache][:avatar].empty?
      @user.avatar.retrieve_from_cache! params[:cache][:avatar]
    end
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @favorite_blogs = @user.favorite_blogs
  end

  private
  def user_params
    params.require(:user).permit(\
      :name, :email, :password, :password_confirmation, :avatar, :avatar_cache)
  end
end
