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
      @wine = Wine.find { |wine| wine.user_id == @user.id }
      if !params[:name].empty? && !params[:winery].empty? && !params[:vintage].empty? && !params[:origin].empty? && !params[:price].empty? && !params[:rating].empty? && !params[:tasting_notes].empty? && @wine.user_id == current_user.id
        @wine.update(name: params[:name], winery: params[:winery], vintage: params[:vintage], origin: params[:origin], price: params[:price], rating: params[:rating], tasting_notes: params[:tasting_notes], other_notes: params[:other_notes])
        redirect "/wines/#{@wine.id}"
      else
        redirect "/wines/#{@wine.id}/edit"
      end
    else
      redirect '/login'
    end
  end

  delete '/wines/:id/delete' do
    if logged_in
      @user = current_user
      @wine = Wine.find { |wine| wine.user_id == @user.id }
      if @wine.user_id == @user.id
        @wine.delete
        redirect '/wines'
      else
        redirect '/wines'
      end
    else
      redirect '/login'
    end
  end
end
