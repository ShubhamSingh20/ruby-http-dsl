require_relative '../mock'

describe Mock do 
  context "When testing the Mock http actions" do 
    it "Should work parse params and query properly" do 
      parsed_uri = ""

      Mock.http do 
        get "http://localhost:8000/api/{version}/users/{user_id}" do
          set_params :user_id, 1500
          set_params :version, :v1

          parsed_uri = uri_with_params
        end
      end

      expect(parsed_uri).to eq "http://localhost:8000/api/v1/users/1500"
    end

    it "Should make GET request with query" do
      resp = nil

      Mock.http do
        set_headers 'Content-Type', 'application/json' 

        get "https://reqres.in/api/users" do
          set_query :page, 2
          resp = response
        end
      end

      expect(resp.code.to_i).to eq 200
    end
  end
end