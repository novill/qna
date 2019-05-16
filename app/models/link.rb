require 'net/http'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true

  validates_format_of :url, :with => URI::regexp(%w(http https))

  def gist_link?
    url=~ /^http(s?):\/\/gist.github.com\/\w+\/\w+/
  end

  def gist_content
    return nil unless gist_link?

    gist_id = /\w+$/.match(url)[0]
    gist_data = JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/gists/#{gist_id}")))
    gist_data['files']&.values&.map{ |file_info| file_info['content'] }&.join(';')
  end
end
