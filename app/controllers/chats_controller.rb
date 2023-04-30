class ChatsController < ApplicationController
  before_action :set_user, only: [:show, :'a', :create, :update]

  # GET /chats or /chats.json

  def index
    if params[:search].present?
      @search_users = User.search_by_email(params[:search], current_user.id)
      @send = []
      @receive = []
      @search_users.each do |user|
        @send.push(UserChat.where(sender_id: current_user.id, receiver_id: user.id).count)
        @receive.push(UserChat.where(sender_id: user.id, receiver_id: current_user.id).count)
      end
    end
    @users = User.all
  end


  # GET /chats/1 or /chats/1.json
  def show
    sender_chat = UserChat.includes(:chat).where(sender_id: current_user.id, receiver_id: @user.id)
    receiver_chat = UserChat.includes(:chat).where(sender_id: @user.id, receiver_id: current_user.id)
    all_chats = sender_chat + receiver_chat
    @chats = all_chats.sort_by { |chat| chat.created_at }

    @chat = Chat.new
  end

  def forward
    @return = User.find(params[:user_id])
    @chat = Chat.find(params[:id])
    @users = User.where.not(id: current_user.id)

  end

  def forward_associate
    @chat = Chat.find(params[:id])
    @all_users = params[:user_ids]
    @all_users.each do |user|
      if user != '0'
     UserChat.create(sender_id: current_user.id, receiver_id: user, chat_id: @chat.id, forwarded: '1')
      end
    end
    redirect_to chats_path
  end
  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit_chat
  def edit
    @update_chat = Chat.find(params[:chat_id])
    @update_user_chat = UserChat.find(params[:user_chat_id])
    @user = User.find(params[:id])
    sender_chat = UserChat.includes(:chat).where(sender_id: current_user.id, receiver_id: @user.id)
    receiver_chat = UserChat.includes(:chat).where(sender_id: @user.id, receiver_id: current_user.id)
    all_chats = sender_chat + receiver_chat
    @chats = all_chats.sort_by { |chat| chat.created_at }

    @chat = Chat.new
    render 'show'
  end


  # POST /chats or /chats.json
  def create
    @find = Chat.find_by(chat_params)
    if @find.present?
    @userchat = UserChat.create(sender_id: current_user.id, receiver_id: @user.id, chat_id: @find.id)
    else
    @chat = Chat.new(chat_params)
      if @chat.save
        @userchat = UserChat.create(sender_id: current_user.id, receiver_id: @user.id, chat_id: @chat.id)
      end
    end
    redirect_to show_chat_url(@user)
  end



  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    @find = Chat.find_by(chat_params)
    @user_chat = UserChat.find(params[:user_chat_id])
    if @find.present?
      @user_chat.update(chat_id: @find.id)
    else
      @chat = Chat.new(chat_params)
      if @chat.save
        @userchat.update(chat_id: @chat.id)
      end
    end
    redirect_to show_chat_url(@user)
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @user_chat = UserChat.find(params[:id])
    @user_chat.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:message)
    end
end
