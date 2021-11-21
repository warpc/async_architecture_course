class Producer < ApplicationService
  def self.call(event:, topic:)
    new(event: event, topic: topic).call
  end

  def initialize(event:, topic:)
    @event = event
    @topic = topic
  end

  def call
    @event.merge!(
      event_id: SecureRandom.uuid,
      event_time: Time.now.to_s,
      # TODO: избегать наименование по сервису. Новое имя?
      producer: 'auth_service'
    )

    result = SchemaRegistry.validate_event(@event, @event[:event_name], version: @event[:event_version])
    if result.success?
      WaterDropProducer.sync_call(@event.to_json, topic: @topic)
    else
      Rails.logger.error "Can't produce event  #{@event} to topic #{@topic}"
    end
  end
end