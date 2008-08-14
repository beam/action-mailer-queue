module ActionMailer
  class Queue < ActionMailer::Base

    @@delivery_method = :activemailer_queue
    cattr_accessor :delivery_method
  
    def self.queue
      return new.queue
    end
  
    def queue
      return Store.create_by_table_name(self.class.to_s.tableize)
    end
  
    def perform_delivery_activemailer_queue(mail)
      store = self.queue.new(:tmail => mail)
      store.save
      mail.queue_id = store.id
      return true
    end
 
  end
end