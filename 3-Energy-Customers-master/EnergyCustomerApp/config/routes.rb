Rails.application.routes.draw do
  get 'homepage/index'  #tells Rails to map requests to 
                        #http://localhost:3000/welcome/index 
                        #to the welcome controller's index action.
  resource :customers #do
      #collection {post :create}
  #end
    
  get '/customers/index', to: 'customers#index', as: 'ranking_list'
  
  
  root 'homepage#index' #tells Rails to map requests to the root 
                        #of the application to the welcome controllers 
                        #index action 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
