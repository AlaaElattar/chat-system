class MessagesController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]

    # POST /applications/:application_token/chats/:chat_number/messages
    def create
        get_chat
        if @chat
            number = RedisHelper.generate_message_number(@chat.id)
            MessagePublisher.publish('messages',{chat_id: @chat.id, number: number, body: message_params[:body]})
            render json: { number: number }, status: :created
        else
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end
    end

    # GET /applications/:application_token/chats/:chat_number/messages/:number
    def show
        get_chat
        if @chat
            @message = @chat.messages.find_by(number: params[:number])
            if @message
                render json: @message, status: :ok
            else
                render json: { error: "Message not found" }, status: :not_found  
            end
        else
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end
    end

    # GET /applications/:application_token/chats/:chat_number/messages
    def index
        get_chat
        if @chat
            @messages = @chat.messages
            if @messages.any?
                render json: @messages, status: :ok
            else
                render json: { error: "No messages found" }, status: :not_found
            end    
        else 
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end   
    end

    
    private

    def get_chat
        @application = Application.find_by(token: params[:application_id])
        if @application
            @chat = @application.chats.find_by(number: params[:chat_id])
        end
    end

    def message_params
        params.require(:message).permit(:body)
    end

end
