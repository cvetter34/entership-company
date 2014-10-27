class RegistrationController < ApplicationController
  before_action :get_registrant

  REGISTRANT_NOT_FOUND = %{
    Registration code not found or expired.
    Please try again.
  }.squish

  def new
    @company = Company.new email: @registrant.email
    @nologin = true
  end

  def create
    if @company = CompanyRegisterer.new(flash).create_new_company_from_registrant(
        @registrant, company_params
      )

      log_company_in_and_redirect( @company )
    else
      flash.now[:alert] = @company.errors
      render :new
    end
  end

  private

  def get_registrant
    unless @registrant = Registrant.find_by_code( params[:code], true )
      flash[:form_type] = "register"
      redirect_to root_url, alert: REGISTRANT_NOT_FOUND
    end
  end

  def company_params
    params.require(:company).permit(
      :password,
      :password_confirmation,
      :package,
      :name,
      :address,
      :address_alt,
      :country_code,
      :phone,
      :website_url,
      :company_type,
      :company_size,
      :contact_person,
      :contact_email,
      :fax,
      :year_founded,
      :description,
      :logo,
      :logo_cache,
      :sectors => []
    )
  end
end
