class ApplicationMailer < ActionMailer::Base
  default from: Settings.email_from_default
  layout "mailer"
end
