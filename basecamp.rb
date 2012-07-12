require 'httparty'
require 'json'

class Basecamp
  attr_accessor :username, :password, :account_endpoint

  def initialize username='', password='', account_endpoint='https://basecamp.com/1908192/api/v1', app='Syllabuster Sync (http://sylly.co)'
    @username = username
    @password = password
    @account_endpoint = account_endpoint
    @app = app
  end

  def headers
    {
      "User-Agent" => @app
    }
  end

  def basic_auth
    {
      :username => @username,
      :password => @password
    }
  end

  def params
    {
      :basic_auth => basic_auth,
      :headers => headers
    }
  end

  def handle response
    if response.code == 200
      JSON.parse(response.body)
    else
      puts response.inspect
      nil
    end
  end

  def projects
    response = HTTParty.get "#{@account_endpoint}/projects.json", params
    handle response
  end

  def project id
    response = HTTParty.get "#{@account_endpoint}/projects/#{id}.json", params
    handle response
  end

  def todolists project_id
    response = HTTParty.get "#{@account_endpoint}/projects/#{project_id}/todolists.json", params
    handle response
  end

  def todolist project_id, todolist_id
    response = HTTParty.get "#{@account_endpoint}/projects/#{project_id}/todolists/#{todolist_id}.json", params
    handle response
  end

  def todos project_id, todo_id
    response = HTTParty.get "#{@account_endpoint}/projects/#{project_id}/todos/#{todo_id}.json", params
    handle response
  end
end