require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "this is in no way secret enough and must be changed later"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    if logged_in?
      redirect '/wines'
    else
      erb :index, :layout => :layout_index_page
    end
  end

  helpers do

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  #if current_user is called the first time, finds session[:user_id] and assigns session to @current_user
    end

    def logged_in?
      !!current_user #"not not current_user" == "is current user" if it is current_user, user is logged in.
    end
  end
end
