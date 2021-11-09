require_relative 'mock'

Mock.url("localhost:8080") do
  set_header 'Authroization-Token', 'token'

  get do
    set_header 'first', 1
    p response
  end

  post do
    set_header 'second', 2
    body {}
  end
end
