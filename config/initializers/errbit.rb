if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.project_id  = Rails.application.secrets.errbit[:project_id]
    config.project_key = Rails.application.secrets.errbit[:project_key]
    config.host        = Rails.application.secrets.errbit[:host]
  end
end