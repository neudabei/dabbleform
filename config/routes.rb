Rails.application.routes.draw do
  #post '/website_email', to: 'submissions#create'
  post '/:account_email', to: 'submissions#create'
end
