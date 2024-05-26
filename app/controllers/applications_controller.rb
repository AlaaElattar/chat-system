class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session, if: -> { request.format.json? }

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
        @application = Application.find_by(token: params[:token])
        if @application
            render json: { token: @application.token, name: @application.name, chats_count: @application.chats_count }
        else
            render json: { error: 'Application not found' }, status: :not_found
        end
    end    

    # GET /applications
    def index
        @applications = Application.all
        render json: @applications.map { |app| { token: app.token, name: app.name, chats_count: app.chats_count } }
    end
        

    private
    def application_params
        params.require(:application).permit(:name)
    end
    
end
