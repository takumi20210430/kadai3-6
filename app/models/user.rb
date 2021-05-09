class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  #フォローする側のuser側からみたRelationshipをactive_relationshipsと命名しておく（なんでも可）親（foreign_key）はフォローする側
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
            #↑の中間table（active_relationships）を介してfollowerモデルのuserを集めることをfollowedsと定義する。
  has_many :followeds, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attachment :profile_image, destroy: false

  def followed_by?(user)
    #follow済みかどうかしらべる
    passive_relationships.find_by(follower_id: user.id).present?
  end

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
   validates :introduction, length:{maximum: 50}
end
