class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :DESC) }

  def set_as_best
    question.answers.update_all("best = (id=#{id})")
    reload
  end
end
