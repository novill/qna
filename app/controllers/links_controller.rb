class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable
    link.destroy if current_user.author_of?(resource)
    redirect_to  resource.is_a?(Question) ? resource : resource.question
  end
end