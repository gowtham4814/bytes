class AddForwardedToUserChats < ActiveRecord::Migration[6.1]
  def change
    add_column :user_chats, :forwarded, :integer
  end
end
