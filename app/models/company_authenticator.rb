class CompanyAuthenticator

  def self.messages
    {
      auth_failed: %{
        Unable to log you in.
        Please check your email and password and try again.
      }.squish
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def authenticate(company_params)
    unless company = Company.authenticate(
        company_params[:email].downcase,
        company_params[:password]
      )

      @flash[:alert] = CompanyAuthenticator.messages[:auth_failed]
    end

    company
  end
end
