class JobsController < ApplicationController
  before_action :is_authenticated?
  before_action :get_job, except: [ :index, :new, :create ]

  def index
    @jobs = @current_company.jobs
  end

  def show
  end

  def new
    @job = Job.new
    @job.company = @current_company
    @job.salary_cents = nil
    @job.posted_on = Date.today
  end

  def create
    @job = @current_company.jobs.create( job_params )
    puts "@job", @job.errors.messages
    if @job.valid?
      if @job.email == @current_company.email
        @job.verify
      else
        JobMailer.coded_email_verification_link(@job).deliver
      end
      redirect_to job_url(@job)
    else
      render :new, alert: @job.errors.messages
    end
  end

  def edit
  end

  def update
    if @job.update_attributes( job_params )
      if @job.email == @current_company.email
        redirect_to job_url(@job), alert: "Updated #{@job.title} successfully."
      else
        @job.request_verification

        JobMailer.coded_email_verification_link(@job).deliver

        redirect_to job_url(@job),
          alert: "Please reverify contact email address (you should receive an email with a code link)."
      end

    else
      flash.now[:alert] = "Can't update the job listing"
      render :edit
    end
  end

  def destroy
    # @job.expire_now
    @job.destroy

    if request.xhr?
      head :ok
    else
      redirect_to jobs_url
    end
  end

  def verify
    @job.request_verification

    JobMailer.coded_email_verification_link(@job).deliver

    redirect_to company_job_url(@job.company, @job), \
      alert: "Please reverify contact email address (you should receive an email with a code link)."
  end

  private

  def job_params
    params.require(:job).permit(
      :title,
      :job_reference,
      :description,
      :responsibilities,
      :ideal_candidate,
      :num_positions,
      :contract_type,
      :sector,
      :city,
      :country_code,
      :postal_code,
      :email,
      :experience_level,
      :salary_cents,
      :salary_currency,
      :salary_frequency,
      :contact_person,
      :posted_on,
      :deadline_on
    )
  end

  def get_job
    @job = @current_company.jobs.find_by( id: params[:id] )

    redirect_to jobs_url unless @job
  end
end
