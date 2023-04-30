Rails.application.routes.draw do
  get 'user/create'
  root to: 'chats#index'
  devise_for :users
  get    '/chats',          to: 'chats#index', as: 'chats'
  post   '/chats/:id',          to: 'chats#create',  as: 'create_chat'
  get    '/chats/new',      to: 'chats#new',    as: 'new_chat'
  get   '/chats/:id/edit/:chat_id/:user_chat_id', to: 'chats#edit',   as: 'edit_chat'
  get    '/chats/:id',      to: 'chats#show',   as: 'show_chat'
  patch  '/chats/:id/:user_chat_id',      to: 'chats#update',  as: 'update_chat'
  delete '/chats/:id',  to: 'chats#destroy', as: 'delete_chat'
  post 'user/create', to:'user#create', as: 'create_user'
  get 'chat/forward/:id/:user_id', to: 'chats#forward', as: 'forward'
  post 'chat/forward/:id/create', to:  'chats#forward_associate', as: 'forward_associate'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
