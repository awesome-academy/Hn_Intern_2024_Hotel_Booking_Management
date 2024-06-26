Devise.setup do |config|
  config.mailer_sender = ENV["host_mail"]
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.lock_strategy = :none
  config.unlock_strategy = :none
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
