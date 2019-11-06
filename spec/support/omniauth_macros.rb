# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info':{
          'nickname' => "fakenick",
          'email' => "user_oauth@test.com",
          "name" => "FAke Name" },
      'credentials' => {
        'token' => 'mock_token'
      }
    })

    OmniAuth.config.mock_auth[:digitalocean] = OmniAuth::AuthHash.new({
      'provider' => 'digitalocean',
      'uid' => '999999',
      'info' => {
        'nickname' => "fakenick",
        'email' => "user_oauth@test.com",
        "name" => "Fake Name" },
      'credentials' => {
        'token' => 'mock_token',
        "expires" => false
      }
    })
  end
end