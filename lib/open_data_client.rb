require "open_data_client/version"
require 'rest-client'
require 'yaml'
require 'json'

module OpenDataClient
  def self.submit_schema
    schema = YAML.load_file('lib/schema.yaml')
    datastore = YAML.load_file('lib/datastore.yaml')

    datastore = RestClient.post "localhost:4000/api/datastores",
                    datastore.to_json,
                    {content_type: :json, accept: :json}
    datastore = JSON.parse(datastore)["data"]

    topic = RestClient.post "localhost:4000/api/datastores/#{datastore['id']}/topics",
                    schema.to_json,
                    {content_type: :json, accept: :json}
    topic = JSON.parse(topic)["data"]

    RestClient.get "localhost:4000/api/datastores/4/topics/#{topic['id']}/create_table",
                    {content_type: :json, accept: :json}
  end

  def get_schema
    datastore = RestClient.post "localhost:4000/api/datastores/1/topics/1/data",
                    {fields: {first_name: "jon", last_name: "doe"}}.to_json,
                    {content_type: :json, accept: :json}

  end
end
