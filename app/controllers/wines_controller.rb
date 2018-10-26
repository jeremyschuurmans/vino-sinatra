class WinesController < ApplicationController

  get '/wines' do
    # @user = User.find(id: params[:user_id])
    erb :'wines/wines'
  end
end
