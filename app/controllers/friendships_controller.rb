class FriendshipsController < ApplicationController
  before_action :set_user, only: [:show]


  def show
    @friendships = current_user.friendships.where("user_id = ? OR friend_id = ?", 5, 5)
  end
  def destroy
    @friendship = Friendship.find_by(params[:friendRequest_id])
    
    if @friendship.destroy
      redirect_to users_path, notice: 'Дружба удалена.'
    else
      redirect_to users_path, alert: 'Не удалось отмудалитьенить заявдружбуку.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
