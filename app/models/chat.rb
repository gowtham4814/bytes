class Chat < ApplicationRecord
  has_many :user_chats
  has_many :senders, through: :user_chats
  has_many :receivers, through: :user_chats
end
