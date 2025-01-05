class Post < ApplicationRecord
  belongs_to :user
  

  # Валидации 
  validates :title, presence: true
  validates :content, presence: true
end
