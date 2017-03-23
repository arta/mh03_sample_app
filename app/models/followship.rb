class Followship < ApplicationRecord
  belongs_to :follower, class_name: 'User' # Rails 5+ auto-validates presence
  belongs_to :followee, class_name: 'User' # - // -
end
