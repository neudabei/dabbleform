Rails.application.routes.draw do
  root to: 'pages#front'

  post '/:account_email', to: 'submissions#create'
  get '/registration', to: 'accounts#create'

  get '/account_verification/:token', to: 'accounts_verification#create', as: 'account_verification'
end
