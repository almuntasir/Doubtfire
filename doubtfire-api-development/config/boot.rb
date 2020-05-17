require 'rubygems'
require 'rails/commands/server'

# Set default binding to 0.0.0.0 to allow connections from everyone if
# under development
if Rails.env.development?
  module Rails
    class Server
      def default_options
        super.merge(Host: '0.0.0.0', Port: 3000)
      end
    end
  end
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
