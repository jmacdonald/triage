class RequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @request = current_user.requests.new
  end

  def create
    @request = current_user.requests.new params[:request]
    
    if @request.save
      redirect_to requests_url
    else
      render 'new'
    end
  end

  def index
    @requests = current_user.requests
  end

  def show
    @request = current_user.requests.find(params[:id])
  end

  def edit
    @request = current_user.requests.find(params[:id])
  end
end
