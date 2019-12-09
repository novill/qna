class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource :user

  def me
    render json: current_resource_owner
  end

  def others
    render json: User.where.not(id: current_resource_owner.id)
  end
end