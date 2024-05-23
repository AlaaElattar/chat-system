class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]

    # POST /applications/:application_token/chats
    def create
        get_application_id
        if @application_id
            number = RedisHelper.generate_chat_number(params[:application_id])
            render json: { number: number }, status: :created
        else
            render json: { error: "Invalid application token" }, status: :unprocessable_entity
        end
    end


    def show
        application = Application.find_by(token: params[:token])
        if application
            chat = application.chats.find_by(number: params[:number])
            render json: chat, status: :ok
        else
            render json: { error: "Invalid application token" }, status: :unprocessable_entity
        end
    end

    private

    def get_application_id
        @application_id = Application.where(token: params[:application_id])
    end    
end