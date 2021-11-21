class Notifier < ApplicationService
  def self.call(payment:)
    new(payment: payment).call
  end

  def initialize(payment:)
    @payment = payment
  end

  def call
    # Stub for payment notification logic
  end
end