class WinesController < ApplicationController

  get '/wines' do
    if logged_in
      @wines = Wine.all
      @user = User.find_by(params[:username])
      erb :'wines/wines'
    else
      redirect '/login'
    end
  end

  get '/wines/new' do
    if logged_in
      erb :'wines/new'
    else
      redirect '/login'
    end
  end

  post '/wines' do
    if !params[:name].empty? && !params[:winery].empty? && !params[:vintage].empty? && !params[:origin].empty? && !params[:price].empty? && !params[:rating].empty? && !params[:tasting_notes].empty?
      @wine = Wine.new(name: params[:name], winery: params[:winery], vintage: params[:vintage], origin: params[:origin], price: params[:price], rating: params[:rating], tasting_notes: params[:tasting_notes], other_notes: params[:other_notes])

      if @wine.save
        @wine.user = current_user
        @wine.save

        redirect "/wines/#{@wine.id}"
      end
    else
      redirect '/wines/new'
    end
  end

  get '/wines/:id' do
    @wine = Wine.find_by(id: params[:id])
    erb :'/wines/show_wine'
  end
end
