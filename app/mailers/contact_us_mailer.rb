class ContactUsMailer < ApplicationMailer
  def send_message
    @contact = params[:contact]
    mail(to: "admin@study2u.com", subject: "Message from Contact Us")
  end
end
