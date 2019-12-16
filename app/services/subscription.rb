module Services
  class Subscription
    def send_subscription(answer, question)
      question.subscriptions.each do |subscription|
        QuestionMailer.question_subscription(subscription.user, answer, question).deliver_later
      end
    end
  end
end