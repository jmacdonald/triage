class AttachmentsController < ApplicationController
  def create
    request = Request.find params[:request_id]
    @attachment = request.attachments.new params[:attachment]
    @attachment.user = current_user

    unless @attachment.save
      flash[:error] = 'Attachment upload failed; please try again.'
    end

    redirect_to request 
  end

  def destroy
    request = Request.find params[:request_id]
    
    redirect_to request 
  end
end
