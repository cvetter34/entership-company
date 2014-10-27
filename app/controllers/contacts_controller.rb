class ContactsController < ApplicationController
  before_action :is_authenticated?, only: [ :create ]

  def new
    if current_company
      @contact = Contact.new
      @contact.company = @current_company
      @nologin = true
    end
  end

  def create
    if @contact = Contact.create( contact_params )
      ContactMailer.contact(@contact).deliver
      ContactMailer.contact_autoreply(@contact).deliver

      redirect_to contact_us_url, notice: "Your message has been sent."
    else
      flash.now[:alert] = "There was a problem sending your message. Please check your form and try again."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit( :subject, :body ).merge( company_id: @current_company.id )
  end
end
