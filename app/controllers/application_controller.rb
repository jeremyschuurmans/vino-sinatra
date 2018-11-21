require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "this is in no way secret enough and must be changed later"
  end

  get "/" do
    if logged_in
      redirect '/wines'
    else
      erb :index, :layout => :layout_index
    end
  end

  helpers do

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

    def logged_in
      !!current_user
    end
  end
end
