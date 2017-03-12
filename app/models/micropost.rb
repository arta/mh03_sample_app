class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true # Redundant? Does `belongs_to :user` run
                                     # `validates :user, presence: true` ?
  validates :content, presence: true, length: { maximum: 140 }
end
