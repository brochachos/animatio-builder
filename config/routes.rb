Builder::Application.routes.draw do
  post 'build' => 'application#build'
end
