class AttachmentsController < ApplicationController

  before_action :authenticate_user!

  skip_authorization_check

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    resource = attachment.record
    attachment.purge if current_user.author_of?(resource)
    redirect_to  resource.is_a?(Question) ? resource : resource.question
  end
end
