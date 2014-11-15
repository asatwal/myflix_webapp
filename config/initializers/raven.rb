require 'raven'

Raven.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.dsn = 'https://0a27c55d31404891b0e6f7732a98939b:fbea3fa8bfad449ead23db27685c182b@app.getsentry.com/33148'
  end
end
