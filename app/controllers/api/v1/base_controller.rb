class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    # puts __FILE__, @current_resource_owner.inspect, Ability.new(@current_resource_owner).can?(:update, Question), '------'
    @current_resource_owner
  end

  alias current_user current_resource_owner
end