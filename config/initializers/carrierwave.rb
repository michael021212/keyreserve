CarrierWave.configure do |config|
  config.aws_bucket = ENV.fetch('AWS_S3_BUCKET')
  config.aws_acl    = 'public-read'

  config.aws_attributes = {
    cache_control: 'max-age=604800'
  }

  config.aws_credentials = {
    access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', ''),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', ''),
    region: ENV.fetch('AWS_REGION')
  }
end
