class SiteController < ApplicationController

  def index
    unless current_company
      p @email = flash[:email]
      p @form_type = flash[:form_type] || 'login'

      @nologin = true
    end
  end

  def about
    @nologin = true if current_company
  end

  def privacy
    @nologin = true if current_company
  end

  def terms
    @nologin = true if current_company
  end
end
