require 'kramdown'

class ContactMailer < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  def contact(contact)
    @contact = contact
    @company = contact.company
    @body = Kramdown::Document.new(contact.body).to_html.html_safe

    headers["X-Company-ID"] = @company.id

    mail to: @company.email, subject: "[EnterShip Company] #{contact.subject}"
  end

  def contact_autoreply(contact)
    @contact = contact
    @company = contact.company
    @body = Kramdown::Document.new(contact.body).to_html.html_safe

    headers["X-Company-ID"] = @company.id

    mail to: @company.email, subject: "[EnterShip Company] WRT '#{contact.subject}'"
  end
end
