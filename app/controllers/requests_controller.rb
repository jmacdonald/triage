class RequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @request = current_user.requests.new
  end

  def index
    @requests = current_user.requests
  end

  def show
    @request = current_user.requests.find(params[:id])
  end
end
