module Tasks
  class Saver < ApplicationService
    def self.call(public_id:, params: {})
      new(*args).call
    end

    def initialize(public_id:, params: {})
      @public_id = public_id
      @params = params
    end

    def call
      task = Task.create_or_update_by_public_id(public_id: @public_id, params: @params)
      PriceAssigner.call(task: task, randomizer: Random.new)
    end
  end
end