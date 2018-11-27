class WinesController < ApplicationController

  get '/wines' do
    if logged_in?
      @user = current_user
      @wines = Wine.all
      erb :'wines/wines'
    else
      redirect '/'
    end
  end

  get '/wines/new' do
    if logged_in?
      @user = current_user
      erb :'wines/new'
    else
      redirect '/'
    end
  end

  post '/wines' do
    if  !params[:name].empty?    &&
        !params[:winery].empty?  &&
        !params[:vintage].empty? &&
        !params[:origin].empty?  &&
        !params[:price].empty?   &&
        !params[:rating].empty?  &&
        !params[:tasting_notes].empty?
        @wine = Wine.new( name: params[:name],
                          winery: params[:winery],
                          vintage: params[:vintage],
                          origin: params[:origin],
                          price: params[:price],
                          rating: params[:rating],
                          tasting_notes: params[:tasting_notes],
                          other_notes: params[:other_notes])
        @wine.user = current_user
       if @wine.save
         redirect "/wines"
       end
    else
     redirect '/wines/new'
    end
  end

  get '/wines/:id/edit' do
    if logged_in?
      @user = current_user
      @wine = Wine.find_by(id: params[:id])
      if @wine.user_id == current_user.id
        erb :'wines/edit'
      else
        redirect '/wines'
      end
    else
      redirect '/'
    end
  end

  patch '/wines/:id' do
    if logged_in?
      @user = current_user
      @wine = Wine.find(params[:id])
      if  !params[:name].empty? &&
          !params[:winery].empty? &&
          !params[:vintage].empty? &&
          !params[:origin].empty? &&
          !params[:price].empty? &&
          !params[:rating].empty? &&
          !params[:tasting_notes].empty? &&
          @wine.user_id == current_user.id
          @wine.update(name: params[:name],
                       winery: params[:winery],
                       vintage: params[:vintage],
                       origin: params[:origin],
                       price: params[:price],
                       rating: params[:rating],
                       tasting_notes: params[:tasting_notes],
                       other_notes: params[:other_notes])
          redirect "/wines"
      else
        redirect "/wines/#{@wine.id}/edit"
      end
    else
      redirect '/'
    end
  end

  delete '/wines/:id' do
    if logged_in? && @wine.user_id == current_user.id
      @wine = Wine.delete(params[:id])
        redirect '/wines'
    else
      redirect back
    end
  end
end
