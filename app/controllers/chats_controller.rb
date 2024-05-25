class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :get_application

    # POST /applications/:application_token/chats
    def create
        if @application
            number = RedisHelper.generate_chat_number(@application.token)
            channel = RabbitmqService.channel
            begin
                MessagePublisher.publish(channel,'chats',{application_id: @application.token, number: number, messages_count: 0 })
            rescue => e 
                puts "Error publishing chat message #{e.message}"   
                return render json: { error: "Failed to publish chat message" }, status: :internal_server_error
            end 
            render json: { number: number }, status: :created
        else
            render json: { error: "Invalid application token" }, status: :unprocessable_entity
        end
    end


    # GET /applications/:application_token/chats/:number
    def show
        if @application
            @chat = Chat.find_by(application_id: @application.id, number: params[:number])
            if @chat
                render json: @chat, status: :ok
            else 
                render json: { error: "Chat not found" }, status: :not_found
            end        
        else
            render json: { error: "Invalid application token" }, status: :unprocessable_entity
        end
    end

    # GET /applications/:application_token/chats
    def index
        if @application
            @chats = Chat.where(application_id: @application.id)
            if @chats
                render json: @chats, status: :ok
            else 
                render json: { error: "No Chats Found" }, status: :not_found
            end        
        else
            render json: { error: "Invalid application token" }, status: :unprocessable_entity
        end
    end    

    private

    def get_application
        @application = Application.find_by(token: params[:application_token])
    end    
end