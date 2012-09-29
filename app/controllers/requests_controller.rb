class RequestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @requests = current_user.requests
  end
end
