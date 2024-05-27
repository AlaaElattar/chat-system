class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    before_action :get_application, only: [:show]

    # POST /applications
    def create
        @application = Application.new(application_params)
        if @application.save
            render json: { token: @application.token }, status: :created
        else 
            render json: @application.errors, status: :unprocessable_entity
        end     
    end
    
    # GET /applications/:token
    def show
        render json: @application.slice(:token, :name, :chats_count)        
    end    

    # GET /applications
    def index
        @applications = Application.select(:token, :name, :chats_count)
        render json: @applications
    end

    
    private

    def get_application
        @application = Application.find_by!(token: params[:token])
    end

    def application_params
        params.require(:application).permit(:name)
    end

    def record_not_found
        render json: { error: 'Application not found' }, status: :not_found
    end
    
end
