class Feature < ActiveRecord::Base
  belongs_to :meeting_room
  belongs_to :service
end
