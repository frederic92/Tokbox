Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users, controllers: { registrations: "registrations" }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'signup', to: 'devise/registrations#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end
end
