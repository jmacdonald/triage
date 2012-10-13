class AttachmentsController < ApplicationController
  def create
    request = Request.find params[:request_id]
    @attachment = request.attachments.new params[:attachment]

    @attachment.save
    redirect_to request 
  end
end
