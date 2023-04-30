class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :sent_user_chats, foreign_key: :sender_id, class_name: "UserChat"
  has_many :received_user_chats, foreign_key: :receiver_id, class_name: "UserChat"
  has_many :sent_chats, through: :sent_user_chats, source: :chat
  has_many :received_chats, through: :received_user_chats, source: :chat

  scope :search_by_email, -> (email, current_user) {
    where("SUBSTR(email, 1, INSTR(email, '@') - 1) LIKE ?", "%#{email}%")
      .where.not(id: current_user)
  }

end
