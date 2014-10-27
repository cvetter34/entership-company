module CompaniesHelper

  def is_my_company?(company)
    @current_company && @current_company.companies.include?(company)
  end
end
