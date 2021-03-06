class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to '/shoes'
    else
      erb :'/users/sign_up'
    end
  end

  get '/users/index' do
    ReleaseScraper.scrape_release
    if logged_in?
      @all_shoes = Shoe.all
      erb :'/users/index'
    else
      redirect to '/login'
    end
  end

  post '/signup' do
    if params[:name] != "" && params[:username] != "" && params[:password] != ""
     @new_user = User.new(:name => params[:name], :username => params[:username], :password => params[:password])
     @new_user.save
     session[:user_id] = @new_user.id
     redirect to '/users/index'
    else
     redirect to '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/users/index'
    else
      erb :'/users/log_in'
    end
  end

  post '/login' do
    @current_user = User.find_by(:username => params[:username])

    if @current_user && @current_user.authenticate(params[:password])
      session[:user_id] = @current_user.id
      redirect to '/shoes'
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session[:user_id] = nil
      redirect to '/'
    else
      redirect to '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :"/users/#{@user.slug}"
  end

end
