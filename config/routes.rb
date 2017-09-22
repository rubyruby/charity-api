Rails.application.routes.draw do
  scope :api do
    get :ping, to: 'application#ping'
    get :contract_balance, to: 'application#contract_balance'
    get :user_info, to: 'application#user_info'

    post :authorize, to: 'application#authorize'

    resources :accounts, only: [:index, :create] do
      get :current, on: :collection
      post :become_member, on: :collection
    end

    resources :proposals, only: [:index, :create] do
      post :vote, on: :member
      post :finish, on: :member
    end

    resources :transactions do
      get :status, on: :member
    end
  end
end
