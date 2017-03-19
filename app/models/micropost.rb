class Micropost < ApplicationRecord
  belongs_to :user
  
  mount_uploader :picture, PictureUploader

  default_scope -> { order( created_at: :desc ) }

  validates :user_id, presence: true # Redundant. Declaring `belongs_to :user` 
                                     #  runs `validates :user, presence: true`
                                     #  or some equivalent
  validates :content, presence: true, length: { maximum: 140 }
end
