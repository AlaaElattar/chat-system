Rails.application.routes.draw do
  resources :applications, param: :token, only: [:create, :show] do
    resources :chats, param: :number, only: [:create, :show, :index] do
      resources :messages, only: [:create, :show, :index]
    end
  end  
end
