class ApplicationMailer < ActionMailer::Base
  default from: 'info@key-stations.com'
  layout 'mailer'
  add_template_helper(ApplicationHelper)
end
