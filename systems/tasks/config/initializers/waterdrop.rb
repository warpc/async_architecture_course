WaterDrop.setup do |config|
  config.deliver = Rails.env.production?
  config.kafka.seed_brokers = ['kafka://kafka:9092']
end