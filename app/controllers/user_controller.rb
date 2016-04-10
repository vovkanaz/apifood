class UserController < ApplicationController

  before_filter :find_user, only: [:edit, :update]

  

  def edit
  end

  def update
    @user.update_attributes(params_for_user)
    unless !@user.errors.empty? || @user.first_name.empty? || @user.last_name.empty? || 
            @user.adress.empty? || @user.phone_number.empty?
      flash[:success] = "Ви успішно зареєструвались"
      redirect_to telegram_path
    else
      flash.now[:error] = "You made mistakes! Please, correct them!"
      render "edit"
    end
  end

  private

  def params_for_user
    params.require(:user).permit(:first_name, :last_name, :company, :adress, :room, :phone_number)
  end

  def find_user
    @user = User.where(name: current_user.name).first
    render_404 unless @user
  end

end