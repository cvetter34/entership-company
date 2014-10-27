class PasswordResetter

  def self.messages
    {
      success: %{ We sent you an email with instructions for
        resetting your password.}.squish,
      company_not_found: %{ Unable to log you in. Please check your email
        and password and try again.}.squish,
      mail_failed: "Unable to send email. Please notify the webmaster.",
      save_failed: "Password reset failed. Please notify the webmaster."
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def set_password_reset_code_and_notify_company(email)
    @company = Company.find_by( email: email )

    if !@company
      @flash[:alert] = PasswordResetter.messages[:company_not_found]
    elsif @company.set_password_reset_code
      send_password_reset_coded_link
    else
      @flash[:alert] = PasswordResetter.messages[:save_failed]
    end
  end

  def update_password(company, company_params)
    if company.reset_password( company_params )
      begin
        CompanyNotifier.password_was_reset( company ).deliver
      rescue
        @flash[:alert] = PasswordResetter.messages[:mail_failed]
      end

      return true
    end
  end

  private

  def send_password_reset_coded_link
    begin
      CompanyNotifier.coded_password_reset_link(@company).deliver

      @flash.now[:notice] = PasswordResetter.messages[:success]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      @flash.now[:alert] = PasswordResetter.messages[:mail_failed]
    end
  end
end
