class Club < ApplicationRecord
  after_create :create_room

  belongs_to :user
  has_many :club_memberships, dependent: :destroy
  has_many :users, through: :club_memberships
  has_many :club_books, dependent: :destroy
  has_many :books, through: :club_books
  has_many :book_categories, through: :books 
  has_many :categories, through: :book_categories

  has_many :rooms, dependent: :destroy
  has_many :room_messages, through: :rooms

  has_many :invites, dependent: :destroy

  def create_room
    Room.create(name: self.name, club_id: self.id)
  end

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 30 }
  has_one_attached :cover_photo

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [:name, :description, :language],
    using: {
      tsearch: { prefix: true }
    }

  def find_current_book
    if self.club_books.find_by(current_book: true).nil?
      'No book'
    else
      self.club_books.find_by(current_book: true).book
    end
  end
end
