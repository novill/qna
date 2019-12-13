class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  def question
    commentable.instance_of?(Question) ? commentable : commentable.question
  end

end
