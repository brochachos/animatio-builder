Builder::Application.routes.draw do
  root :to     => 'application#index'
  post 'build' => 'application#build'
end
