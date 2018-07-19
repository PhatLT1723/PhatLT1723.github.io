Rails.application.routes.draw do
  resources :answers
  resources :questions
  resources :groups
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'users#index'
  get 'update_user', to: 'users#update_mod'
  get 'create_user', to: 'users#create_mod'

  get 'update_group', to: 'groups#update_mod'
  get 'create_group', to: 'groups#create_mod'

  get 'update_question', to: 'questions#update_mod'
  get 'create_question', to: 'questions#create_mod'
end
