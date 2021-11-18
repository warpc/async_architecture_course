class WaterDropProducer
  def self.sync_call(event, topic:)
    self.new.sync_call(event, topic)
  end

  def initialize
    @producer = WaterDrop::Producer.new

    @producer.setup do |config|
      config.kafka = { 'bootstrap.servers': 'kafka:9092' }
    end
  end

  def sync_call(event, topic)
    @producer.produce_sync(topic: topic, payload: event)
  ensure
    @producer.close
  end
end