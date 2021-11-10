require_relative 'mock'

Mock.http do
  set_cookies 'id_token', 'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTI5OTMyNywicGhvbmUiOm51bGwsImVtYWlsIjoibWFyZGlyYWJpbjQ5MEBnbWFpbC5jb20iLCJleHAiOjE2MzY1MzY0MDYsImlhdCI6MTYzNjUzMjgwNn0.YqhVC9rVBlwARYh2RB2__DzMYu_CzuRxpmcr7E_GE78'

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
