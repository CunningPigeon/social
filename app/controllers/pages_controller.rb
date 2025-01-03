class PagesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
  end

  def update
    Rails.logger.debug "Обновление пользователя: #{@user.inspect}, параметры: #{user_params.inspect}"

    if @user.update(user_params)
      redirect_to profile_path, notice: 'Профиль успешно обновлен.'
    else
      Rails.logger.debug "Ошибки при обновлении: #{@user.errors.full_messages.join(", ")}"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, notice: 'Пользователь успешно удален.'
  end

  private 

  def set_user
    @user = User.find(params[:id]) # Находим пользователя по ID из параметров
    Rails.logger.debug "Пользователь загружен: #{@user.inspect}" # Выводим информацию о пользователе в лог
  end

  def user_params
    params.require(:user).permit(:name, :email, :surname, :patron, :nickname, 
    :gender, :date_birth, :type_activity, :company, :description)
  end
end
