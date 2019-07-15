class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    question_id = data['question_id'].split('-')[1]
    channel_name = "answers_question_#{question_id}"
    Rails.logger.info channel_name
    stream_from channel_name
  end
end