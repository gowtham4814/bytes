require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create(email: 'other@example.com', password: 'password') }

  describe 'GET index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    it 'returns a successful response' do
      sign_in user
      get :show, params: { id: other_user.id }
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    it 'creates a new chat and redirects' do
      sign_in user
      post :create, params: { chat: { message: 'Hello' }, id: other_user.id }
      expect(response).to redirect_to(show_chat_url(other_user))
    end
  end

  describe 'PATCH update' do
    it 'updates an existing chat and redirects' do
      sign_in user
      chat = Chat.create(message: 'Hello')
      user_chat = UserChat.create(sender_id: user.id, receiver_id: other_user.id, chat_id: chat.id)
      patch :update, params: { chat: { message: 'Updated' }, user_chat_id: user_chat.id, id: other_user.id }
      expect(response).to redirect_to(show_chat_url(other_user))
    end
  end

  describe 'DELETE destroy' do
    it 'destroys an existing chat and redirects' do
      sign_in user
      chat = Chat.create(message: 'Hello')
      user_chat = UserChat.create(sender_id: user.id, receiver_id: other_user.id, chat_id: chat.id)
      delete :destroy, params: { chat_id: chat.id, id: other_user.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
