RSpec.shared_examples "API linkable" do
  it 'returns all' do
    expect(links_response.size).to eq(links.size)
  end

  it 'returns names and urls' do
    links_response.each do |link_response|
      link = links.select {|link| link.id == link_response['id']}[0]
      expect(link_response['name']).to eq(link.name)
      expect(link_response['url']).to eq(link.url)
    end
  end

end