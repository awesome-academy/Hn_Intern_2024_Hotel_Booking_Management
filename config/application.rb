require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module HotelBooking
  class Application < Rails::Application
    config.load_defaults 7.1
    config.i18n.available_locales = %i(en vi)
    config.i18n.default_locale = :en

    config.logger = Logger.new(STDOUT)
  end
end
