class CreateUserChats < ActiveRecord::Migration[6.1]
  def change
    create_table :user_chats do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :chat, null: false, foreign_key: true
      t.timestamps
    end
  end
end
