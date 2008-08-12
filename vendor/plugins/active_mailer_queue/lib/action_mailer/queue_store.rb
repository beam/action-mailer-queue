module ActionMailer
  class Queue < ActionMailer::Base
    class Store < ActiveRecord::Base
    
      class MailAlreadySent < StandardError; end 
    
      def self.create_by_table_name(table_name)
        self.set_table_name table_name
        return self
      end
    
      def self.process!(options = {})
        options = { 
            :limit => 100,
            :conditions => ["sent = ?", false],
            :order => "priority asc, last_attempt_at asc"
          }.merge(options)
        self.find(:all, options) #.each { |q| q.deliver! }
      end
    
      def tmail=(mail)
        self.to = mail.to.uniq.join(",")
        self.from = mail.from.uniq.join(",")
        self.subject = mail.subject
        self.content = mail.encoded
      end
    
      def to_tmail
        tmail = TMail::Mail.parse(self.content)
        tmail.to = self.to.split(",") unless self.to.blank?
        tmail.from = self.from.split(",") unless self.from.blank?
        tmail.subject = self.subject unless self.subject.blank?
        return tmail
      end
    
      def resend!
        self.sent = false
        self.save
        self.deliver!
      end
    
      def deliver!
        raise MailAlreadySent if self.sent == true
        mail = Mailer.deliver(self.to_tmail)
        self.message_id = mail.message_id
        self.sent = true
        self.sent_at = Time.now
        self.save
        return mail
      rescue => err
        raise MailAlreadySent if err.class == ActionMailer::Queue::Store::MailAlreadySent 
        self.tries += 1
        self.last_error = err.to_s
        self.last_attempt_at = Time.now
        self.save
        return false
      end
    
    end
  end  
end