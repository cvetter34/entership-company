class JobMailer < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  def coded_email_verification_link(job)
    @job = job

    headers["X-Job-ID"] = @job.id

    mail to: @job.email, subject: "[EnterShip] Please verify email address for \"#{@job.title}\""
  end

  def email_is_verified(job)
    @job = job

    headers["X-Job-ID"] = @job.id

    mail to: @job.email, subject: "[EnterShip] \"#{@job.title}\" email verified"
  end
end
