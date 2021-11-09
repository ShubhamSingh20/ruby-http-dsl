require_relative 'mock'

Mock.url("http://localhost:4000/api/{version}/refresh_streak_data") do
  set_cookies 'id_token', 'eyJhbGciOiJIUzI1NiJ9'

  post do
    set_params :version, 'v2'
    set_body {:streak_data => null}

    response
  end

  delete do
    set_params :version, 'v1'

    response
  end
end
