  module ApiHelpers

    def api_headers
      {"CONTENT_TYPE" => "application/json",
       "ACCEPT" => 'application/json'}
    end

    def api_form_headers
      api_headers.merge('Content-Type' => 'application/x-www-form-urlencoded')
    end
    def json
      @json ||= JSON.parse(response.body) if response && !response.body.blank?
    end

    def do_request(method, path, options = {})
      send method, path, options
    end
  end