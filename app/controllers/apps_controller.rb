class AppsController < ApplicationController
  before_action :is_authenticated?, except: [ :redirect ]
  before_action :get_app, except: [ :index, :new, :create, :redirect ]
  before_action :get_job, except: [ :redirect ]

  def index
    @apps = @current_company.apps.order( status: :desc )
  end

  def show
  end

  def update
    msg = if params[:approved]
      @app.status = App.ok_statuses["approved"]
      "approved"
    elsif params[:declined]
      @app.status = App.ok_statuses["declined"]
      "declined"
    else
      @app.status = App.ok_statuses["pending"]
      "pending"
    end
    @app.save
    redirect_to apps_url, notice: "Application #{msg}."
  end

  def destroy
    @app.destroy
    redirect_to apps_url, alert: "Application deleted."
  end

  def redirect
    if app = App.find_by( link_code: params[:code] ) and
        company = app.job.company
      app.update_attributes( link_code: nil )
      session[:redirect_to] = job_app_url( app.job, app )
      log_company_in_and_redirect(company)
    else
      redirect_to root_url, alert: "Sorry, that link has expired."
    end
  end

  private

  def get_app
    @app = @current_company.apps.find_by( id: params[:id] )

    redirect_to root_url, alert: "Can't find that app." unless @app
  end

  def get_job
    if params[:job_id]
      @job = @current_company.jobs.find_by( id: params[:job_id] )

      redirect_to apps_url, alert: "Can't find that job listing." unless @job
    end
  end

  def app_params
    params.require(:app).permit( :status )
  end
end
