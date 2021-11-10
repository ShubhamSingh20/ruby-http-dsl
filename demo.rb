require_relative 'mock'

Mock.http do
  set_cookies 'id_token', 'jwt-token'

  post "http://localhost:4000/api/{version}/refresh_streak_data" do
    set_params :version, 'v2'

    p json
  end

  get "http://localhost:4000/api/{version}/top_leader_board/streak" do
    set_query :limit, 2
    set_params :version, 'v1'

    puts json
  end
end
