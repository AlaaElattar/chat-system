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
        

    private
    def application_params
        params.require(:application).permit(:name)
    end
    
    # def fetch_application(token)
    #     # check if the application cached in redis
    #     cached_application = $redis.get("application:#{token}")

    #     # If exists return it to the user
    #     if cached_application
    #         application = JSON.parse(cached_application)
    #     else
    #         # If not exists, get it from database then cache it 
    #         application = Application.find_by(token: token)
    #         if application
    #             $redis.set("application:#{token}", application.to_json, ex: 3600)
    #         end    
    #     end

    #     application    
    # end    

end
