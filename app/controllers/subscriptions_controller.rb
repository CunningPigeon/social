class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show]
  before_action :store_location, only: [:destroy]

  def show
    @user = User.find(params[:id]) 
    @followers = @user.followers
    @subscription_ids = @user.subscriptions.pluck(:follower_id) # переделать
  end

  def create
    Rails.logger.debug "Создаем подписку для пользователя: #{params[:id]}"
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    
    redirect_to @user, notice: 'Вы подписались на пользователя.'
  end

  def destroy
    Rails.logger.debug "Запрос на отписку: #{params[:id]}"
    @user = User.find(params[:id]) 
    # @subscription = Subscription.find_by(follower_id: current_user.id, followed_id: params[:user_id])
    @subscription = Subscription.find(params[:user_id])
    
    if @subscription.destroy
      # current_user.unfollow(@subscription.id)
      @subscription.destroy
      redirect_to session[:return_to], notice: 'Подписка успешно удалена.'
    else
      redirect_to session[:return_to], alert: 'Не удалось отписать(ся).'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def store_location
    # Cодержит URL страницы, с которой пришёл пользователь
    session[:return_to] = request.referer
  end
end
