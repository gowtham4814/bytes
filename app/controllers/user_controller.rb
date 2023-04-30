class UserController < ApplicationController
  skip_before_action :authenticate_user!
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_session_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to new_user_registration_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
