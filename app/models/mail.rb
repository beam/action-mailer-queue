class Mail < ActionMailer::Queue
  
  def test
    @recipients = "testovka@seznam.cz"
    @from = "spam@meeen.net"
    @subject = "Subject"
  end
  
end