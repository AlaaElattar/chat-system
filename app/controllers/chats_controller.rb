class ChatsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, only: [:create]

    # TODO: creates right, but same chat id counter(not incrementing)
    # POST /applications/:application_token/chats
    def create
        get_application_id
        if @application_id
            chat = Chat.create(application_id: @application_id, number: Chat.where(application_id: @application_id).count + 1)
            puts "chat.number: #{chat.number}"
            render json: { number: chat.number }, status: :created
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