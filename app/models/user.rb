class User < ApplicationRecord
  has_many :posts
  has_many :comments

  # Подписки
  has_many :subscriptions, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :subscriptions, source: :followed

  # Подписчики
  has_many :inverse_subscriptions, class_name: 'Subscription', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :inverse_subscriptions, source: :follower
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2] 
         
  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end

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

  private

  def date_birth_cannot_be_in_the_future
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_birth, "Не может быть в будущем")
    end
  end
end
