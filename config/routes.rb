Rails.application.routes.draw do
  post '/submission', to: 'submissions#create'
end
