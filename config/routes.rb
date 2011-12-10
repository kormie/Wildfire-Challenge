FbBase::Application.routes.draw do
  get 'facebook/show/:id' => 'facebook#show'
  match 'facebook/:action' => 'facebook', :as => :facebook
  root :to => 'facebook#index'
end
