class TweetsController < ApplicationController

    # tweets index
    get '/tweets' do
      # does not load /tweets index if user is not logged in
      # does load /tweets index if user is logged in
      if logged_in?
        # set instance variable as current_user via helper method
        @user = current_user
        # makes all tweets available via instance variable
        @tweets = Tweet.all
  
        # loads tweet index
        erb :'tweets/tweets'
      else
        redirect to "/login"
      end
    end
  
    # create
    get '/tweets/new' do
      # user can view new tweet form if logged in
      # user can create tweet if logged in
      # user cannot view new tweet form if not logged in
      if logged_in?
        erb :'/tweets/create_tweet'
      else
        redirect '/login'
      end
    end
  
    # create
    post '/tweets' do
      # does not let user create a blank tweet
      if !params[:content].empty?
        # tweet is saved as logged in user
        tweet = Tweet.create(content: params[:content], user: current_user)
        tweet.save
              
        redirect '/tweets'
      else
        redirect to '/tweets/new'
      end
    end
  
    # read
    get '/tweets/:id' do
      # logged in user can view a single tweet
      # logged out user cannot view a single tweet
      if logged_in?
        # sets tweet id to instance variable to that tweet's data can be viewed
        @tweet = Tweet.find_by_id(params[:id])
  
        erb :'tweets/show_tweet'
      else
        # if not logged in redirects user to login page
        redirect to '/login'
      end
    end
  
    # update
    get '/tweets/:id/edit' do
      # sets tweet id to instance variable to that tweet's data can be viewed/edited
      @tweet = Tweet.find_by(params[:id])
  
      # lets a user use tweet edit form if logged in
      # does not let a user edit a tweet they did not create
      # if user is logged in can edit their own tweet
      if logged_in? && @tweet.user_id == current_user.id
        erb :'/tweets/edit_tweet'
      else
        # does not load edit form if user not logged in, redirects to login page
        redirect '/login'
      end
    end
  
    # update
    patch '/tweets/:id' do
      if logged_in?
        if params[:content] == ""
          redirect to "/tweets/#{params[:id]}/edit"
        else
          @tweet = Tweet.find_by_id(params[:id])
          if @tweet && @tweet.user == current_user
            if @tweet.update(content: params[:content])
              redirect to "/tweets/#{@tweet.id}"
            else
              redirect to "/tweets/#{@tweet.id}/edit"
            end
          else
            redirect to '/tweets'
          end
        end
      else
        redirect to '/login'
      end
    end
  
    delete '/tweets/:id/delete' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          @tweet.delete
        end
        redirect to '/tweets'
      else
        redirect to '/login'
      end
    end
  end