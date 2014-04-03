WearfleetWeb::Application.routes.draw do
   devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
   resources :fleets do
     resources :devices
   end

   resources :users do
     resources :devices
   end

   resources :devices
   root to: 'home#index'
end
