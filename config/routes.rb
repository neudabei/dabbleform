Rails.application.routes.draw do
  post '/:email', to: 'submissions#create'
end
