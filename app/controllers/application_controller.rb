class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper

  before_filter :authenticate!
end
