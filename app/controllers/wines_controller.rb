class WinesController < ApplicationController

  get '/wines' do
    if logged_in
      @wines = Wine.all
      @user = User.find_by(params[:username])
      @users = User.all

      erb :'wines/wines'
    else
      redirect '/login'
    end
  end

  get '/wines/new' do
    if logged_in
      @user = current_user
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

        redirect "/wines"
      end
    else
      redirect '/wines/new'
    end
  end

  get '/wines/:id' do
    if logged_in
      @wine = Wine.find_by(id: params[:id])
      erb :'wines/show_wine'
    else
      redirect '/login'
    end
  end

  get '/wines/:id/edit' do
    if logged_in
      @user = current_user
      @wine = Wine.find_by(id: params[:id])
      if @wine.user_id == current_user.id
        erb :'wines/edit'
      end
    else
      redirect '/login'
    end
  end

  patch '/wines/:id' do
    if logged_in
      @user = current_user
      @wine = Wine.find(params[:id])
      if !params[:name].empty? && !params[:winery].empty? && !params[:vintage].empty? && !params[:origin].empty? && !params[:price].empty? && !params[:rating].empty? && !params[:tasting_notes].empty? && @wine.user_id == current_user.id
        @wine.update(name: params[:name], winery: params[:winery], vintage: params[:vintage], origin: params[:origin], price: params[:price], rating: params[:rating], tasting_notes: params[:tasting_notes], other_notes: params[:other_notes])
        redirect "/wines"
      else
        redirect "/wines/#{@wine.id}/edit"
      end
    else
      redirect '/login'
    end
  end

  delete '/wines/:id' do
    if logged_in
      @user = current_user
      @wine = Wine.delete(params[:id])
        redirect '/wines'
    else
      redirect '/login'
    end
  end
end
