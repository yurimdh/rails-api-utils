Rails.application.routes.draw do
  get    "/me",              to: "users#me"
  get    "/users",           to: "users#index"
  get    "/users/private",   to: "users#private"
  get    "/users/:id",       to: "users#show"
  post   "/users",           to: "users#create"
  delete "/users/:id",       to: "users#destroy"
  get    "/error",           to: "application#render_500"
  get    "*unmatched_route", to: "application#render_404"
end
