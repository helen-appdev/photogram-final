# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# make uploads available, take 3
require "carrierwave/orm/activerecord"