Rails.application.routes.draw do
  #post '/website_email', to: 'submissions#create'
  post '/:account_email', to: 'submissions#create'
  get '/registration', to: 'accounts#create'

  get '/account_verification/:token', to: 'accounts_verification#create', as: 'account_verification'
end
