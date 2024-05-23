class ChatsController < ApplicationController
    # handle pagination for large number of chats
    skip_before_action :verify_authenticity_token, only: [:create]
    def create
        @application = Application.find_by(token: params[:token])
        if @application
            chat = @application.chats.create(number: @application.chats.count + 1)
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
end