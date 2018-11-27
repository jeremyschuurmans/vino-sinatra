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
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  #if @current_user returns false, calls User.find_by_id if User.id exists in session hash.
    end

    def logged_in?
      !!current_user #since current_user returns true, !current_user would make current_user false, but !!current_user makes it true. Basically user is logged in if user is "not not the current user"
    end
  end
end
