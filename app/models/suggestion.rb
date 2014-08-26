class Suggestion < ActiveRecord::Base
  belongs_to :user
  validates :comment, presence: true
  validates :user_id, presence: true
end
