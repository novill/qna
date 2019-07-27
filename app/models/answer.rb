class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  default_scope { order(best: :DESC) }

  def set_as_best
    transaction do
      question.answers.update_all("best = (id=#{id})")
      question.reward&.update!(user: user)
    end
    reload
  end
end
