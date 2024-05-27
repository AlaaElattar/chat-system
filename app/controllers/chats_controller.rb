class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :get_application, :get_application_chat
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # POST /applications/:application_token/chats
    def create
        if @application
            number = RedisHelper.generate_chat_number(@application.token)
            channel = RabbitmqService.channel
            begin
                MessagePublisher.publish(channel,'chats',{application_id: @application.id, number: number, messages_count: 0 })
                render json: { number: number }, status: :created
            rescue => e 
                return render json: { error: "Failed to publish chat message" }, status: :internal_server_error
            end 
        end
    end


    # GET /applications/:application_token/chats/:number
    def show
        render json: @chat, status: :ok     
    end

    # GET /applications/:application_token/chats
    def index
        puts "INSPECT #{@application.chats.inspect}"
        render json: @application.chats, status: :ok
    end    

    private

    def get_application
        @application = Application.find_by(token: params[:application_token])
    end    

    def get_application_chat
        @chat = @application.chats.find_by(number: params[:number]) if @application
    end

    def record_not_found
        render json: { error: 'Record not found' }, status: :not_found
    end
end