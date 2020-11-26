class RoomMessage < ApplicationRecord
  belongs_to :room
  belongs_to :user
  belongs_to :room, inverse_of: :room_messages
  has_one :club, through: :room
end
