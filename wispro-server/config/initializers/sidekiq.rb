Sidekiq.configure_server do |config|
    config.redis = {
        url: 'redis://localhost:5001/0'
    }
end

Sidekiq.configure_client do |config|
    config.redis = {
        url: 'redis://localhost:5001/0'
    }
end