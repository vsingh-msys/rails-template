Rails.application.routes.draw do

  get 'dashboard/index'

	resources :articles
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	devise_for :users, 
				controllers: { sessions: 'users/sessions',
	 						   registrations: 'users/registrations',
	  						   passwords: 'users/passwords' },
	   		    path_names: { sign_in: 'login',
							  sign_out: 'logout',
							  password: 'secret',
							  confirmation: 'verification',
							  registration: 'register',
							  sign_up: 'signup' }

	authenticated :user do
    	root 'dashboard#index', as: :authenticated_root
  	end
	root 'welcome#index'
end
