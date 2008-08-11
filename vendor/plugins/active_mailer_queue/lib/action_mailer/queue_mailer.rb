module ActionMailer
  class Queue < ActionMailer::Base
    class Mailer < ActionMailer::Base; end
  end
end