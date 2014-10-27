crumb :root do
  link "Home", root_url
end

crumb :jobs do
  link "Jobs", jobs_url
end

crumb :job do |job|
  link job.title, job_url(job)
  parent :jobs
end

crumb :job_new do
  link "New job listing", new_job_url
  parent :jobs
end

crumb :job_edit do |job|
  link "Edit job listing", edit_job_url(job)
  parent :job, job
end

crumb :apps do
  link "Job applications", apps_url
end

crumb :app do |app|
  link app.name, job_app_url(app.job, app)
  parent :apps
end

crumb :profile do |company|
  link company.name, profile_url
end

crumb :profile_edit do |company|
  link "Edit profile", edit_profile_url
  parent :profile, company
end
