module Payments
  class Processor < ApplicationService
    def self.call(payment:)
      new(payment: payment).call
    end

    def initialize(payment:)
      @payment = payment
    end

    def call
      # Stub for payment processing logic
    end
  end
end

