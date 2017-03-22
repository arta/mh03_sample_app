class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User' # Rails 5+ auto-validates presence
  belongs_to :followed, class_name: 'User' # - // -
end
