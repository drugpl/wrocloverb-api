WrocLove::Application.routes.draw do
  namespace :api do
    resources :speakers, except: :edit
    resources :supporters, except: :edit
    resources :organizers, except: :edit
    resources :venues, except: :edit
    resources :attendees, except: :edit
  end
end
