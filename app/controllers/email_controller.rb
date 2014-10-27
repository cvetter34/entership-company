class EmailController < ApplicationController
  before_action :is_authenticated?, except: [ :update ]

  def resend
    if @job = Job.find_by(id: params[:id])
      JobMailer.coded_email_verification_link(@job).deliver
    else
      flash[:alert] = "Sorry, couldn't find that job listing."
    end

    redirect_to @job.nil? ? jobs_url : job_url(@job)
  end

  def update
    if @job = Job.find_by_code( params[:code] )
      @job.verify

      JobMailer.email_is_verified(@job).deliver

      redirect_to job_url(@job),
        notice: "Contact email for #{@job.title} is verified and job is public!"
    else
      redirect_to root_url,
        alert: "Can't find that job listing! Perhaps you already validated it?"
    end
  end
end
