class SessionController < ApplicationController

  def new
    redirect_to root_url, notice: "You are logged in." if current_company
    @nologin = true
    @form_type = "login"
  end

  def create
    case params[:form]
    when "login"
      company = CompanyAuthenticator.new(flash).authenticate(company_params)
      return if log_company_in_and_redirect( company )
    when "reset"
      PasswordResetter.new(flash).set_password_reset_code_and_notify_company(company_params[:email])
    when "register"
      CompanyRegisterer.new(flash).create_a_new_registrant(company_params[:email])
    else
      flash[:alert] = "There was a problem with the form. Please check your inputs and try again."
    end

    flash[:email] = company_params[:email]

    redirect_to root_url
  end

  def destroy
    log_company_out_and_redirect
  end

  private

  def company_params
    params.require(:company).permit( :email, :password )
  end
end
