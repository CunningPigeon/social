class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  def show
    @followers = @user.followers
  end

  def create
    Rails.logger.debug "Создаем подписку для пользователя: #{params[:id]}"
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    
    redirect_to @user, notice: 'Вы подписались на пользователя.'
  end

  def destroy
    Rails.logger.debug "Запрос на отписку: #{params[:id]}"
    @user = User.find(params[:user_id]) 
    @subscription = Subscription.find_by(follower_id: current_user.id, followed_id: params[:user_id])
    
    if current_user.unfollow(@subscription.id)
      current_user.unfollow(@subscription.id)
      redirect_to @user, notice: 'Вы отписались от пользователя.'
    else
      redirect_to @user, alert: 'Не удалось отписаться от пользователя.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
