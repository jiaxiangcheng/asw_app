Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, Rails.application.secrets.google_oauth2_part1, Rails.application.secrets.Rails.application.secrets.google_oauth2_part2
end