require 'omniauth'
require 'omniauth-twitter'
require 'dm-core'
require 'dm-migrations'
require 'sinatra'
require 'haml'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/scrobblehop-web.db")

require_relative 'user'

DataMapper.finalize
DataMapper.auto_upgrade!

use OmniAuth::Strategies::Twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']

configure do
  set :session_secret, ENV['COOKIE_SECRET']
  enable :sessions
end

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end
end

get '/' do
  if current_user
    redirect '/account'
  else
    haml :index
  end
end

get '/fetch' do
  error 403 unless params[:key] = ENV['BACKTRACKS_API']
  users = User.all.map { |u| { email: u.email, username: u.lastfm_user } }
  users.to_json
end

get '/account' do
  redirect '/' unless current_user
  haml :account
end

post '/account' do
  error 400 unless current_user

  @current_user.update(email: params[:email], lastfm_user: params[:username])
  redirect '/account', 303
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  User.first_or_create({uid: auth["uid"]})
  user = User.first(uid: auth["uid"])
  success = user.update(uid: auth["uid"], nickname: auth["info"]["nickname"])
  session[:user_id] = user.id
  redirect '/'
end

get '/sign_in' do
  redirect '/auth/twitter'
end

get '/sign_out' do
  session[:user_id] = nil
  redirect '/'
end
