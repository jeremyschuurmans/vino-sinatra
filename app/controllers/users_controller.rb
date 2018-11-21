class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect back
    else
      redirect '/'
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty?
      @user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
      if @user.save
        session[:user_id] = @user.id #logs user in
        redirect '/wines'
      end
    else
      redirect '/'
    end
  end

  patch '/signup' do  #updates user info when user submits edit account info form
    if logged_in?
      @user = current_user
      @user.update(name: params[:name], email: params[:email], username: params[:username], password: params[:password])
      @user.save
      redirect back
    end
  end

  get '/login' do
    if logged_in?
      redirect back
    else
      redirect '/'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password]) #if user exists and password is valid
      session[:user_id] = @user.id #logs user in
      redirect '/wines'
    else
      redirect '/'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do  #user profile page
    @user = User.find_by_slug(params[:slug])
    @user = current_user
    erb :'/users/show'
  end
end
