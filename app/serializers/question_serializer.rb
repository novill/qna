class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files
  has_many :answers
  has_many :comments, as: :commentable
  belongs_to :user
  #has_many :files
  has_many :links, serializer: LinksSerializer

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map{ |file| {id: file.id, filename: file.filename.to_s, link: Rails.application.routes.url_helpers.url_for(file)} }
  end
end
