Rails.application.routes.draw do
  root to: 'pages#front'

  post '/:account_email', to: 'submissions#create'
  get '/registration', to: 'accounts#create'

  get '/websites_verification/:token', to: 'websites_verification#verify', as: 'website_verification'
end
