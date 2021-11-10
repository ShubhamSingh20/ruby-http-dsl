# HTTP DSL

A simple DSL, to poke around and work with ruby's meta programming concepts.

```ruby
Mock.http do
	# these configs will be shared across all the http actions
  set_cookies 'id_token', 'XXXXXX'
	set_headers 'Host', 'build-failed-successfully.com'
	set_headers 'Content-Type', 'application/json'

	# configs specified in a specific action will only be limited
	# to that action
	get "http://localhost:4000/api/{version}/user/top" 
		set_query :limit, 5
		set_query :order, :asc
    set_params :version, :v2

		json
	end

  post "http://localhost:4000/api/{version}/refresh_streak_data" do
    set_params :version, :v2
    set_body {:data => 100, :message => :ok}

    response
  end

  delete "http://localhost:4000/api/{version}/users/{user_id}" do
		get_user_id = -> { some logic to get user id}

    set_params :user_id, get_user_id.call
		set_params :version, :v1

    response
  end
end
```

To run tests, do

- `bundler install`
- `rspec`