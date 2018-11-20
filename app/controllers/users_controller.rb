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
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
      if @user.save
        session[:user_id] = @user.id
        redirect '/wines'
      end
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in
      @user = current_user
      redirect '/wines'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/wines'
    else
      redirect '/'
    end
  end

  get '/logout' do
    if logged_in
      session.destroy
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    # @user = User.find_by_slug(params[:slug])
    @user = current_user
    @wine = Wine.find { |wine| wine.user_id == @user.id }
    # binding.pry

    erb :'/users/show'
  end

end
