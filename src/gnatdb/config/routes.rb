ActionController::Routing::Routes.draw do |map|
  
 
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  
  # Restful Authentication Resources
  # map.resources :users do |user|
  #   user.resource :passwords
  #   user.resource :session
  #   user.resources :data_points
  # end
  
  map.resources :users
  map.resources :passwords
  map.resource :session
  map.resources :data_points, :as=>"data"
    
  # Home Page
  map.root :controller => 'home', :action => 'index'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
