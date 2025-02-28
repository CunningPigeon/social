class FriendRequestsController < ApplicationController
# Связи и ассоцияации построены
# Вывод всех пользователь
# Поиск пользователя
# Фильтрация пользователей
  before_action :set_user, only: [:show]


  def show
    @user = User.find(params[:id])
    # @sent_friend_requests = current_user.friend_requests
    
    # Получаем все отправленные заявки текущего пользователя
    @sent_friend_requests = @user.friend_requests
  
    # Получаем все полученные заявки текущего пользователя
    @received_friend_requests = @user.inverse_friend_requests
  end

  def create
    @friend_request = FriendRequest.new(sender_id: current_user.id, receiver_id: params[:user_id])
    
    if @friend_request.save
      redirect_to users_path, notice: 'Заявка в друзья отправлена.'
    else
      redirect_to users_path, alert: 'Не удалось отправить заявку.'
    end
  end

  def destroy
    @friend_request = FriendRequest.find_by(params[:friendRequest_id])
    
    if @friend_request.destroy
      redirect_to users_path, notice: 'Заявка в друзья отменена.'
    else
      redirect_to users_path, alert: 'Не удалось отменить заявку.'
    end
  end
  

  def accept
    @friend_request = FriendRequest.find(params[:id])
  
    if Friendship.create(user_id: current_user.id, friend_id: @friend_request.sender_id)
      @friend_request.destroy
      redirect_to users_path, notice: 'Заявка в друзья принята.'
    else
      redirect_to users_path, alert: 'Не удалось принять заявку в друзья.'
    end
  end

  def decline
    @friend_request = FriendRequest.find(params[:friendRequest_id])
    @friend_request.destroy
    redirect_to users_path, notice: 'Заявка в друзья отклонена.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def store_location
    session[:return_to] = request.referer
  end
  
end
