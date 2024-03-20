class ApplicationMailer < ActionMailer::Base
  default from: ENV["host_mail"]
  layout "mailer"
end
