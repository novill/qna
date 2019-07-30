class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    question_id = data['question_id']
    channel_name = "comments_question_#{question_id}"
    Rails.logger.info channel_name
    stream_from channel_name
  end
end