class ProfileController < ApplicationController
  before_action :is_authenticated?

  def show
    @company = @current_company
  end

  def update
    @company = @current_company

    if @company.update_attributes( company_params )
      redirect_to profile_url, notice: "Your profile has been updated."
    else
      render "show", alert: @company.errors
    end
  end

  def destroy
    # @current_company.update_attributes( deleted_at: Time.now )
    @current_company.destroy

    if request.xhr?
      head :ok
    else
      log_company_out_and_redirect
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :address,
      :address_alt,
      :country_code,
      :company_type,
      :company_size,
      :contact_person,
      :contact_email,
      :phone,
      :mobile,
      :fax,
      :website_url,
      :year_founded,
      :description,
      :year_founded,
      :logo,
      :logo_cache,
      :sectors => []
    )
  end
end
