RSpec.shared_examples "API attachable" do
  it 'returns all' do
    expect(attachments_response.size).to eq(attachments.size)
  end

  it 'returns filenames and links' do
    attachments_response.each do |attached_response|
      attached = attachments.select {|file| file.id == attached_response['id']}[0]
      expect(attached_response['filename']).to eq(attached.filename.to_s)
      expect(attached_response['link']).to eq(Rails.application.routes.url_helpers.url_for(attached))
    end
  end
end