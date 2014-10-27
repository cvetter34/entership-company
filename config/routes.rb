Rails.application.routes.draw do
  root 'site#index'

  get    'about'          => 'site#about',          as: :about_us           # works
  get    'privacy'        => 'site#privacy',        as: :privacy_policy     # works - shared
  get    'terms'          => 'site#terms',          as: :terms_of_use       # works - shared

  get    'contact'        => 'contacts#new',        as: :contact_us         #
  post   'contact'        => 'contacts#create'

  # Log in/out
  post   'login'          => 'session#create',      as: :log_in
  delete 'logout'         => 'session#destroy',     as: :log_out

  # Registration
  get    'register/:code' => 'registration#new',    as: :registration_form
  post   'register/:code' => 'registration#create', as: :register

  # Password reset
  get    'reset/:code'    => 'password#edit',       as: :password_reset_form
  patch  'reset/:code'    => 'password#update',     as: :reset_password

  # Email verification
  patch  'resend/:id'     => 'email#resend',        as: :verify_job
  get    'verify/:code'   => 'email#update',        as: :email_verification

  # One-time app link
  get    'apps/redirect/:code'  => 'apps#redirect', as: :one_time_redirect

  # Company profile
  get    'profile'        => 'profile#show',        as: :profile
  get    'profile/edit'   => 'profile#edit',        as: :edit_profile
  patch  'profile'        => 'profile#update'
  delete 'profile'        => 'profile#destroy'

  resources :apps, only: [ :index, :show ]

  resources :jobs do
    resources :apps, except: [ :index, :new, :create, :edit ]
  end
end
