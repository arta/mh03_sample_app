if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_usernmae => ENV['RACKSPACE_USERNAME'],
      :rackspace_api_key  => ENV['RACKSPACE_API_KEY']
    }
    config.fog_directory = ENV['RACKSPACE_CONTAINER']
  end
end
