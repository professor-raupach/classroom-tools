Rails.application.routes.draw do

  devise_for :users


  namespace :admin do
    resources :users
    resources :courses do
      member do
        get :attendance_report, to: "attendance_reports#show"
        get :attendance_report_csv, to: "attendance_reports#csv"
      end
    end
  end

  namespace :student do
    resources :courses, only: [:index] do
      member do
        post :enroll
        delete :unenroll
      end
    end
    resources :help_requests, only: [:new, :create, :destroy, :show]do
      get :removed, on: :collection
    end
    resources :attendance_checkins, only: [:new, :create, :show]
  end
  get "/hq/:help_queue_id", to: "student/help_requests#new", as: :short_help_request
  get "/ac/:id", to: "student/attendance_checkins#new", as: :short_attendance_checkin


  namespace :instructor do
    resources :help_queues, only: [:index, :new, :create, :show] do
      member do
        get :list  # /instructor/help_queues/:id/list
        get :manage   # /instructor/help_queues/:id/manage (for instructors/tutors to manage)
      end
    end
    resources :help_requests, only: [:destroy]
    resources :courses do
      member do
        get :attendance_report, to: "attendance_reports#show"
        get :attendance_report_csv, to: "attendance_reports#csv"
      end
      post :start_attendance  # triggers find-or-create CourseSession and redirects
      resources :course_sessions, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        resource :attendance_checkin, only: [:show, :create] do
          post :end  # for when countdown expires
          get :closed # for closed screen
        end
      end
    end

  end







  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root "home#index"
  # get "pages/home"
  # get "users/sign_out" => "pages#home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
