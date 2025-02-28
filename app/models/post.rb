class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  

  # Валидации 
  validates :title, presence: true
  validates :content, presence: true
end
