class MessagesController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :get_application, :get_chat

    # TODO: add linter

    # POST /applications/:application_token/chats/:chat_number/messages
    def create
        if @chat
            number = RedisHelper.generate_message_number(@chat.number)
            channel = RabbitmqService.channel
            begin
                MessagePublisher.publish(channel ,'messages',{chat_id: @chat.number, number: number, body: params[:body]})
                render json: { number: number }, status: :created
            rescue => e
                render json: { error: "Failed to publish message: #{e.message}" }, status: :internal_server_error
            end            
        else
            render json: { error: "Invalid chat number" }, status: :unprocessable_entity
        end
    end

    # GET /applications/:application_token/chats/:chat_number/messages/:number
    def show
        @message = Message.find_by(number: params[:number])
        if @message
            render json: @message, status: :ok
        else
            render json: { error: "Message not found" }, status: :not_found  
        end
    end

    # GET /applications/:application_token/chats/:chat_number/messages
    def index
        render json: @chat.messages, status: :ok   
    end

    # GET /applications/:application_token/chats/:chat_number/messages/search?query=:query
    def search
        query = params[:query]
        @messages = Message.search(query, @chat.id).records
        render json: @messages, status: :ok
    end
    
    private

    def get_application
        @application = Application.find_by(token: params[:application_token])
    end

    def get_chat
        @chat = @application.chats.find_by(number: params[:chat_number]) if @application
        render json: { error: 'Invalid chat number' }, status: :unprocessable_entity unless @chat
    end

    def message_params
        params.permit(:body)
    end
end
