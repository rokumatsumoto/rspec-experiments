# frozen_string_literal: true

RSpec.shared_context 'API helpers' do
  include Rack::Test::Methods

  # before do
  #   basic_authorize 'test_user', 'test_password'
  # end

  def xml_last_response
    Ox.parse_obj(last_response.body)
  end

  def json_last_response
    JSON.parse(last_response.body)
  end

  def helpers
    app.helpers
  end

  def header_json
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
  end

  def header_xml
    header 'Accept', 'text/xml'
    header 'Content-Type', 'text/xml'
  end
end
