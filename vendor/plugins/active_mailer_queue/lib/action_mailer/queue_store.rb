module ActionMailer
  class Queue < ActionMailer::Base
    class Store < ActiveRecord::Base
    
      def self.create_by_table_name(table_name)
        self.set_table_name table_name
        return self
      end
    
      def tmail=(mail)
        self.to = mail.to
        self.from = mail.from
        self.subject = mail.subject
        self.content = mail.encoded
      end
    
      def to_tmail
        tmail = TMail::Mail.parse(self.content)
        tmail.to = self.to unless self.to.blank?
        tmail.from = self.from unless self.from.blank?
        tmail.subject = self.subject unless self.subject.blank?
        return tmail
      end
    
      def deliver!
        Mailer.deliver(self.to_tmail)
      rescue
        false
      end
    
    end
  end  
end