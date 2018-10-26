class UsersController < ApplicationController

  get '/signup' do
    if logged_in
      @user = current_user
      redirect '/wines'
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if !params[:name].empty? && !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect '/wines'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    erb :'/users/login'
  end
end
