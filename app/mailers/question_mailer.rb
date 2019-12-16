class QuestionMailer < ApplicationMailer
  def question_subscription(user, answer, question)
    @answer = answer
    @question = question
    mail(to: user.email, subject: 'New answer for subscribed question')
  end
end