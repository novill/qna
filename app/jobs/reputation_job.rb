class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::ReputationJob.calculate(object)

  end
end
