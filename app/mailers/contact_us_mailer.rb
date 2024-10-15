class ContactUsMailer < ApplicationMailer
  def send_message
    @contact = params[:contact]
    mail(to: "admin@bikinapp.com", subject: "Message from Contact Us")
  end
end
