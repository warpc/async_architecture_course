class HomeController < ApplicationController
  before_action :check_authentication
  before_action :check_authorization

  def index
    @daily_statistics = DailyStatistic.all.order('date Desc')
  end
end
