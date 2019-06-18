class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :password)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :github_link, :avatar, :password)
  end
end
