Rails.application.routes.draw do
  resources :applications, param: :token, only: [:create, :show, :index] do
    resources :chats, param: :number, only: [:create, :show, :index] do
      resources :messages, param: :number,only: [:create, :show, :index] do
        collection do
          get 'search'
        end
      end
    end
  end  
  get '/healthcheck', to: 'healthchecks#healthcheck'
end
