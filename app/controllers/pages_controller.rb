class PagesController < ApplicationController
  before_action :set_user, only: %i[edit update show]

  def index
    @users = User.all
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
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
  
   #@user = current_user
  
  if @user.destroy
    Rails.logger.debug "Пользователь успешно удален: #{@user.inspect}"
    redirect_to root_path, notice: 'Пользователь успешно удален.'
  else
    Rails.logger.debug "Ошибка при удалении пользователя: #{@user.errors.full_messages.join(", ")}"
    redirect_to root_path, alert: 'Не удалось удалить пользователя.'
  end
  end
  

  private 

  def set_user
    @user = User.find(params[:id]) 
    Rails.logger.debug "Пользователь загружен: #{@user.inspect}" 
  end

  def user_params
    params.require(:user).permit(:name, :email, :surname, :patron, :nickname, 
    :gender, :date_birth, :type_activity, :company, :description)
  end
end
