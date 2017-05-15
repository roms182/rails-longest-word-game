Rails.application.routes.draw do
  get 'welcome', to: 'game#welcome'
  get 'display/:grid&:start', to: 'score#display'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
