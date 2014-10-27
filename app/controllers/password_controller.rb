class PasswordController < ApplicationController
  PASSWORD_RESET_SUCCESSFUL = "Your password has been successfully reset."

  COMPANY_NOT_FOUND = %{ Sorry, your reset link has expired.
    Please generate a new one.}.squish

  def edit
    unless @company = Company.find_by_code( params[:code] )
      flash[:form_type] = "reset"
      redirect_to root_url, notice: COMPANY_NOT_FOUND
    end
    @nologin = true
  end

  def update
    if @company = Company.find_by_code( params[:code] )
      resetter = PasswordResetter.new(flash)

      if resetter.update_password( @company, company_params )
        flash[:notice] = PASSWORD_RESET_SUCCESSFUL
        log_company_in_and_redirect( @company )
      else
        flash.now[:alert] = @company.errors
        render :edit
      end
    else
      flash[:form_type] = "reset"
      redirect_to root_url, alert: COMPANY_NOT_FOUND
    end
  end

  private

  def company_params
    params.require(:company).permit( :password, :password_confirmation )
  end
end
