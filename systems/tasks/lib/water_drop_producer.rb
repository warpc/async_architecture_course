require 'waterdrop'

class WaterDropProducer
  def self.sync_call(event, topic:)
    self.new.sync_call(event, topic)
  end

  def sync_call(payload, topic)
    WaterDrop::SyncProducer.call(payload, topic: topic)
  end
end