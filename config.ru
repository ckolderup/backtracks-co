require 'rubygems'
require 'bundler'

Bundler.require
use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
use Rack::Logger

require './scrobblehop-web'
run BackTracks
