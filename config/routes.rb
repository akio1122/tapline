Getadvice::Application.routes.draw do
  apipie
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  get "/:id" => "shortener/shortened_urls#show"

  root "welcome#landing"

  get "dispatch/receive_message" => "dispatch#receive_message"
  post "dispatch/receive_call" => "dispatch#receive_call"
  post "dispatch/update_call" => "dispatch#update_call"

  devise_for :experts

  get "customers/edit_email" => "customers#edit_email"
  put "customers/update_email" => "customers#update_email"

  scope "/experts" do
    resources :advice_sessions do
      put :end, on: :member
      get :end_by_link, on: :collection
    end

    resources :ratings, only: [:new, :create]
  end

  api_version module: 'Api::V1', path: {value: 'api/v1'}, default: true do
    post 'request-session' => 'advice_sessions#create'
    post 'rate-session' => 'ratings#create'
  end

end
