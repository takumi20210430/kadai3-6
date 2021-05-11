class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def self.looks(searches, words)
		if searches == "perfect_match"
			 @book = Book.where("title LIKE ?", "#{words}")

		elsif searches == "forward_match"
			@book = Book.where("title LIKE ?", "#{words}%")

		elsif searches == "backword_match"
			@book = Book.where("title LIKE ?", "%#{words}")
		else
			 @book = Book.where("title LIKE ?", "%#{words}%")
		end
	end
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
