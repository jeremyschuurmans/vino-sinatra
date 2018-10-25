require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "this is in no way secret enough and must be changed later"
  end

  get "/" do
    erb :index
  end

end
