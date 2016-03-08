Rails.application.routes.draw do
  get  "/users",           to: "users#index"
  get  "/users/:id",       to: "users#show"
  post "/users",           to: "users#create"
  get  "*unmatched_route", to: "application#render_404"
end
