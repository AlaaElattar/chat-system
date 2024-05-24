class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]

    # POST /applications/:application_token/chats
    def create
        get_application
        if @application
            number = RedisHelper.generate_chat_number(@application.token)
            channel = RabbitmqService.channel
            begin
                puts "HELLO BEFORE"
                MessagePublisher.publish(channel,'chats',{application_id: @application.token, number: number, messages_count: 0 })
                puts "HELLO AFTER"
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
        get_application
        if @application
            Rails.logger.debug("Application: #{@application.inspect}")
            Rails.logger.debug "All Chats: #{@application.chats.inspect}"
            @chat = Chat.where(application_id: @application.token, number: params[:id])
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
        get_application
        if @application
            @chats = Chat.where(application_id: @application.token)
            puts "CHATS #{@chats}"
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