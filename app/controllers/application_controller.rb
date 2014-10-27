class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_company

  before_action :detect_device_format
  before_filter :make_action_mailer_use_request_host_and_protocol

  def current_company
    if @current_company ||= Company.find_by( id: session[:company_id] )
      @open_jobs ||= @current_company.open_jobs
      @open_apps ||= @current_company.open_apps
    end

    @current_company
  end

  def is_authenticated?
    unless current_company
      session[:redirect_to] = request.fullpath
      redirect_to root_url
    end
  end

  def hide
    redirect_to request.referer || root_url
  end

  def log_company_in_and_redirect(company)
    if company
      session[:company_id] = company.id

      default_path = company.has_open_apps? ? root_url : jobs_url

      path = session[:redirect_to] || default_path
      session[:redirect_to] = nil

      redirect_to path
    end
  end

  def log_company_out_and_redirect
    session[:company_id] = nil
    redirect_to root_url, notice: "You've successfully logged out."
  end

  private

  def detect_device_format
    if browser.tablet?
      request.variant = :tablet
    elsif browser.mobile?
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
