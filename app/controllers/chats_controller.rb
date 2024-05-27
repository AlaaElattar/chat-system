class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :get_application
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # POST /applications/:application_token/chats
    def create
        if @application
            number = RedisHelper.generate_chat_number(@application.token)
            channel = RabbitmqService.channel
            begin
                MessagePublisher.publish(channel,'chats',{application_id: @application.token, number: number, messages_count: 0 })
                render json: { number: number }, status: :created
            rescue => e 
                return render json: { error: "Failed to publish chat message" }, status: :internal_server_error
            end 
        end
    end


    # GET /applications/:application_token/chats/:number
    def show
        @chat = Chat.find_by(application_id: @application.id, number: params[:number])
        render json: @chat, status: :ok     
    end

    # GET /applications/:application_token/chats
    def index
        @chats = Chat.where(application_id: @application.id)    
        render json: @chats, status: :ok
    end    

    private

    def get_application
        @application = Application.find_by(token: params[:application_token])
    end    

    def record_not_found
        render json: { error: 'Record not found' }, status: :not_found
    end
end