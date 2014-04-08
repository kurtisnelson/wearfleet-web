WearfleetWeb::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :fleets do
    resources :devices
    resources :memberships
    get :watch
    put :leave
    put :approve
  end

  resources :users do
    collection do
      post :pusher_auth
    end
    resources :devices
  end

  resources :devices
  root to: 'home#index'
end
