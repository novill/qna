class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    @last_day_questions = Question.where("created_at > ?", 1.day.ago)


    mail to: user.email, subject: 'QnA question digest', from: 'noanswer@localhost'
  end
end
