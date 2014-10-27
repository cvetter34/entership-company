class CompanyRegisterer

  def self.messages
    {
      success: %{ We sent you an email with instructions for
        completing your registration.}.squish,
      welcome: %{
        You have successfully completed your EnterShip registration and
        are logged in. Welcome to EnterShip!
      }.squish,
      already_registered: "You are already registered. Reset your password?",
      mail_failed: "Unable to send email. Please notify the webmaster.",
      save_failed: "Registration failed. Please notify the webmaster."
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def create_a_new_registrant(email)
    if Company.find_by( email: email )
      @flash[:alert] = CompanyRegisterer.messages[:already_registered]
      @flash[:form_type] = "reset"
    else
      @registrant = Registrant.find_or_initialize_by(
        email: email, is_company: true
      )

      if @registrant.save
        send_sign_up_coded_link
      else
        @flash[:alert] = CompanyRegisterer.messages[:save_failed]
      end
    end
  end

  def create_new_company_from_registrant(registrant, company_params)
    params = company_params.merge( email: registrant.email )

    if (company = Company.create( params )) and company.valid?
      registrant.destroy
      send_welcome_email(company)

      @flash.now[:notice] = CompanyRegisterer.messages[:welcome]
    else
      @flash.now[:alert] = company.errors.messages
    end

    company
  end

  private

  def send_sign_up_coded_link
    begin
      CompanyNotifier.coded_registration_link(@registrant).deliver

      @flash.now[:notice] = CompanyRegisterer.messages[:success]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      @flash.now[:alert] = CompanyRegisterer.messages[:mail_failed]
    end
  end

  def send_welcome_email(company)
    begin
      CompanyNotifier.welcome(company).deliver
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      # Fail silently
    end
  end
end
