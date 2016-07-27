require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'pry-byebug'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib/all' # Requires cookies, among other things

# Load other key tools
require 'twilio-ruby'
require 'rmagick'
require 'chatterbot/dsl'
require 'net/http'

include Magick # Necessary?

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Global Sinatra configuration
configure do
  set :root, APP_ROOT.to_path
  set :server, :puma

  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'lighthouselabssecret'

  set :views, File.join(Sinatra::Application.root, "app", "views")

  # Load all services from app/services, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'services', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end
end


# Development and Test Sinatra Configuration
configure :development, :test do
  require 'pry'
end

# Production Sinatra Configuration
configure :production do
  # NOOP
end

# Set up the database and models
require APP_ROOT.join('config', 'database')

# Load the routes / actions
require APP_ROOT.join('app', 'actions')

# Set up the chatbot
# require APP_ROOT.join('config', 'chatbot.yml')
