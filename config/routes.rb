Geview::Application.routes.draw do
  resources :tracks
  match "/graph/:chromosome/:level(/:center)" => "page#graph", :as => :graph
  match 'about' => "page#about"
  match 'select_data' => "page#select_data"
  match 'summary' => "page#summary"
  root :to => "page#home"
end
