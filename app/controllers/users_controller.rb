class UsersController < ApplicationController

  # create
  get '/signup' do
      # does not let a logged in user view the signup page
      if logged_in?
          redirect "/tweets"
      end
      
      # loads the signup page
      erb :"/users/create_user"
  end

  # create 
  post '/signup' do
      # create user
      user = User.new(username: params[:username], email: params[:email], password: params[:password])

      # does not let a user sign up without a username
      # does not let a user sign up without an email
      # does not let a user sign up without a password
      if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
          # save user to db
          user.save
          # adds user_id to sessions hash
          # log user in
          session[:user_id] = user.id
          # signup directs user to twitter index
          redirect "/tweets"
      else
          redirect "/signup"
      end
  end

  get '/login' do
      # does not let user view login page if already logged in
      if logged_in?
          redirect "/tweets"
      end

      # loads the login page
      erb :'/users/login'
  end

  post '/login' do
      # searches for username in db that matches username entered at login page
      user = User.find_by(username: params[:username])


      # verifies password in db matches password entered at login
      if user && user.authenticate(params[:password])
          # if both username are found/pw matches sets user_id to session id, enabling cookies 
          session[:user_id] = user.id
          # loads the tweets index after login
          redirect '/tweets'
      else
          # if username/pw not found or entered incorrectly sends user back to login page
          redirect '/signup'
      end
  end

  # read
  get '/users/:slug' do
      # slugs username
      # finds user based on slug
      @user = User.find_by_slug(params[:slug]) 

      #shows all sing users tweets
      erb :"/users/show"
  end

  get '/logout' do
      # lets a user logout if they are already logged in
      # does not let a user logout if not logged in
      # clears sessions so user cannot access certain areas of site without logging in again
      session.clear
      redirect '/login'
end

end