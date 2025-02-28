class User < ApplicationRecord
  has_many :posts
  has_many :comments

  # Подписки
  has_many :subscriptions, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :subscriptions, source: :followed

  # Подписчики
  has_many :inverse_subscriptions, class_name: 'Subscription', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :inverse_subscriptions, source: :follower

  # Отправитель заявки в друзья 
  has_many :friend_requests, foreign_key: :sender_id, dependent: :destroy
  has_many :receiver_users, through: :friend_requests, source: :receiver

  # Принимающий заявку в друзья
  has_many :inverse_friend_requests, class_name: 'FriendRequest', foreign_key: :receiver_id, dependent: :destroy
  has_many :senders, through: :inverse_friend_requests, source: :sender

  # Отправленные дружбы
  has_many :friendships, foreign_key: :user_id, dependent: :destroy
  has_many :friends, through: :friendships, source: :friends

  # Полученные дружбы
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2] 
         
  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end

  # Подписки/отписки
  def follow(user)
    subscriptions.find_or_create_by(followed_id: user.id)
  end

  def unfollow(subscription_id)
    subscription = subscriptions.find_by(id: subscription_id)
    subscription&.destroy
  end

  def following?(user)
    subscriptions.exists?(followed_id: user.id)
  end

  # Заявки
  def friend_request?(user)
    friend_requests.exists?(receiver_id: user.id)
  end

  def sending_friend_request(user)
    friend_requests.find_or_create_by(receiver_id: user.id)
  end

  def cancel_friend_request(subscription_id)
    friend_request = friend_requests.find_by(id: friend_request_id)
    friend_request&.destroy
  end

  # Дружба
  def unfriend(friend)
    friendships.find_by(friend: friend)&.destroy
  end

  def friends_with?(friend)
    friends.include?(friend)
  end

  private

  def date_birth_cannot_be_in_the_future
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_birth, "Не может быть в будущем")
    end
  end
end
