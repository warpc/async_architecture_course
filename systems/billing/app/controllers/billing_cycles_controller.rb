class BillingCyclesController < ApplicationController
  before_action :check_authentication
  before_action :check_authorization

  # GET /billing_cycles or /billing_cycles.json
  def index
    @billing_cycles = BillingCycle.order('id DESC')
  end
end
