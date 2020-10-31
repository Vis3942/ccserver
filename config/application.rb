require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ccserver
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths << "#{Rails.root}/lib"


    config.active_record.schema_format = :sql

    #config.exceptions_app = self.routes

    initializer(:remove_activestorage_routes, after: :add_routing_paths) {|app|
      app.routes_reloader.paths.delete_if {|path| path =~ /activestorage/}}

      initializer(:remove_actionmailbox_routes, after: :add_routing_paths) {|app|
        app.routes_reloader.paths.delete_if {|path| path =~ /actionmailbox/}}


  end
end
