class WinesController < ApplicationController

  get '/wines' do
    if logged_in
      erb :'wines/wines'
    else
      redirect '/login'
    end
  end
end
