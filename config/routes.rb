Recorder::Application.routes.draw do
  root :to => "home#list"
  match 'all' => "home#index"
  match 'sessions' => "home#sessions"
  match ':controller(/:action(/:id(.:format)))'
end
