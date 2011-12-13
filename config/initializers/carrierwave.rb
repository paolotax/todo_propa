if Rails.env.test? # Store the files locally for test environment
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

if Rails.env.development? or Rails.env.production? # Using Amazon S3 for Development and Production
  CarrierWave.configure do |config|
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'uploads'

    config.storage = :fog
    config.fog_credentials = {
        :provider => 'AWS', # required
        :aws_access_key_id => 'AKIAJ3UJ5NO7Q4NVWQUA', # required
        :aws_secret_access_key => '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', # required
    }
    config.fog_directory = 'todopropa' # required
  end
end