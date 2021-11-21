module Payments
  class Processor < ApplicationService
    def self.call(payment:)
      new(*args).call
    end

    def initialize(payment:)
      # Stub for payment processing logic
    end
  end
end

