class WinesController < ApplicationController

  get '/wines' do
    erb :'wines/wines'
  end
end
