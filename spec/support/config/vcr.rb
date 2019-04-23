VCR.configure do |config|
  config.cassette_library_dir = "#{ ::Rails.root }/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.filter_sensitive_data('<GOOGLE_API_KEY>') { Settings.google_key }
  config.configure_rspec_metadata!
end
