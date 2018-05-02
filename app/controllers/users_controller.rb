class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    already_exists_email = User.find_by(email: params[:user][:email].downcase)
    
# print "already_exists_email:"
# p already_exists_email

    if !already_exists_email && @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      if already_exists_email != nil
        flash.now[:danger] = "email is already exists"
      end
      
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  private
  def user_params
    params.require(:user).permit(\
      :name, :email, :password, :password_confirm)
  end
end
