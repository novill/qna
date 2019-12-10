class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :files
  has_many :comments
  has_many :links, serializer: LinksSerializer

  def files
    object.files.map{ |file| {id: file.id, filename: file.filename.to_s, link: Rails.application.routes.url_helpers.url_for(file)} }
  end

end
