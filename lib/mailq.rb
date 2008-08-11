module TMail
  class Mail
    attr_accessor :queue_id
  end
end

module ActionMailer

  # V modelech musi vznikat Mailer s ActionMailer::Queue

  class Queue < ActionMailer::Base

    # Rozsireme Base a udelame accessor pro nastaveni typu dorucovani z fronty
    # => enviroment.rb - ActionMailer::Queue.delivery_method_from_queue = :smtp
    
    @@delivery_method_from_queue = :smtp
    cattr_accessor :delivery_method_from_queue
  
    class DontKnowHowToDeliveryEmail < StandardError; end  
  
    def self.queue
      return new.queue
    end
  
    def queue
      return Store.create_by_table_name(self.class.to_s.downcase.pluralize)
    end
  
    def perform_delivery_activemailer_queue(mail)
      store = self.queue.new(:tmail => mail)
      store.save
      mail.queue = store.id
      return true
    end
  
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
        Mailer.delivery_method = ActionMailer::Queue.delivery_method_from_queue
        raise DontKnowHowToDeliveryEmail if Mailer.delivery_method == :activemailer_queue
        Mailer.deliver(self.to_tmail)
      end
    
    end
  
    class Mailer < ActionMailer::Base; end
  
  end

end