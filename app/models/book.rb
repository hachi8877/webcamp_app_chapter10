class Book < ApplicationRecord

#  belongs_to :user, foreign_key: [:user_id]
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  # has_many :books, foreign_key: [:user_id], dependent: :destroy
end
