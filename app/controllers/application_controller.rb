# typed: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate!, :set_paper_trail_whodunnit

private

  include ApplicationHelper

  def not_found
    raise ActionController::RoutingError.new("Not Found")
  end
end
