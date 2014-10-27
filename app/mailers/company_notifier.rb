class CompanyNotifier < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  CODED_RESET_LINK          = "[EnterShip:Company] Reset your credentials"
  PASSWORD_WAS_RESET        = "[EnterShip:Company] Your password has been reset!"
  CODED_REGISTRATION_LINK   = "[EnterShip:Company] Complete your registration"
  WELCOME_NEW_COMPANY       = "[EnterShip:Company] Welcome to EnterShip!"

  def coded_password_reset_link(company)
    @company = company

    headers["X-Company-ID"] = @company.id

    mail to: @company.email, subject: CODED_RESET_LINK
  end

  def password_was_reset(company)
    @company = company

    headers["X-Company-ID"] = @company.id

    mail to: @company.email, subject: PASSWORD_WAS_RESET
  end

  def coded_registration_link(registrant)
    @registrant = registrant

    headers["X-Registrant-ID"] = @registrant.id

    mail to: @registrant.email, subject: CODED_REGISTRATION_LINK
  end

  def welcome(company)
    @company = company

    headers["X-Company-ID"] = @company.id

    mail to: @company.email, subject: WELCOME_NEW_COMPANY
  end
end
