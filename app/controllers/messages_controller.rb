class MessagesController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :get_application, :get_chat

    # POST /applications/:application_token/chats/:chat_number/messages
    def create
        if @chat
            number = RedisHelper.generate_message_number(@chat.number)
            channel = RabbitmqService.channel
            MessagePublisher.publish(channel ,'messages',{chat_id: @chat.number, number: number, body: params[:body]})
            render json: { number: number }, status: :created
        else
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end
    end

    # GET /applications/:application_token/chats/:chat_number/messages/:number
    def show
        if @chat
            puts "Number #{params[:number]}"
            @message = Message.find_by(chat_id: @chat.number, number: params[:number])
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
        if @chat
            @messages = Message.where(chat_id: @chat.number)
            if @messages
                render json: @messages, status: :ok
            else
                render json: { error: "No messages found" }, status: :not_found
            end    
        else 
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end   
    end

    # GET /applications/:application_token/chats/:chat_number/body/search
    def search
        query = params[:query]
        @messages = @chat ?  Message.search(query, @chat.number).records : []
        render json: @messages, status: :ok
    end
    
    private

    def get_application
        @application = Application.find_by(token: params[:application_token])
    end

    def get_chat
        @chat = @application.chats.find_by(number: params[:chat_number]) if @application
    end

    def message_params
        params.permit(:body)
    end
end
