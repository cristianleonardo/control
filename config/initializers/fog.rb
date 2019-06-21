# CarrierWave.configure do |config|
#   config.fog_provider = 'fog/aws'                        # required
#   config.fog_credentials = {
#     provider:              'AWS',                        # required
#     aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
#     aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
#     region:                'us-west-2',                  # optional, defaults to 'us-east-1'
#   }
#   config.fog_directory  = Rails.application.secrets.fog_directory
#   config.fog_public     = false                                                 # optional, defaults to true
#   config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
# end
