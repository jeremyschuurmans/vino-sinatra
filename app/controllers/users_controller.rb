class UsersController < ApplicationController

  get '/signup' do
    erb :'users/signup'
  end
end
